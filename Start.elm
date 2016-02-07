module Start (start, address) where

import GameOfLife exposing (evolve)
import Types exposing (..)
import Time exposing (..)


actions : Signal.Mailbox (List Action)
actions =
  Signal.mailbox []


singleton : Action -> List Action
singleton action =
  [ action ]


address : Signal.Address Action
address =
  Signal.forwardTo actions.address singleton


type Message
  = Actions (List Action)
  | Evolve Float


update : Action -> Model -> Model
update action model =
  let
    xMin =
      model.viewPort.xMin

    yMin =
      model.viewPort.yMin

    xMax =
      model.viewPort.xMax

    yMax =
      model.viewPort.yMax

    cellSize =
      model.viewPort.cellSize
  in
    case action of
      NoOp ->
        model

      ToggleRunning ->
        { model | running = not model.running }

      Up ->
        { model | viewPort = ViewPort xMin (yMin - 1) xMax (yMax - 1) cellSize }

      Down ->
        { model | viewPort = ViewPort xMin (yMin + 1) xMax (yMax + 1) cellSize }

      Left ->
        { model | viewPort = ViewPort (xMin - 1) yMin (xMax - 1) yMax cellSize }

      Right ->
        { model | viewPort = ViewPort (xMin + 1) yMin (xMax + 1) yMax cellSize }

      ZoomOut ->
        { model | viewPort = ViewPort (xMin - 1) (yMin - 1) (xMax + 1) (yMax + 1) (cellSize - 2) }

      ZoomIn ->
        { model | viewPort = ViewPort (xMin + 1) (yMin + 1) (xMax - 1) (yMax - 1) (cellSize + 2) }

      UpdateUniverse string ->
        let
          newUniverse =
            snd (Maybe.withDefault ( "", [] ) (List.head (List.filter (\i -> (fst i) == string) model.examples)))
        in
          { model | universe = newUniverse }


unifiedUpdate : Message -> Model -> Model
unifiedUpdate message model =
  case message of
    Evolve _ ->
      if model.running then
        { model | universe = evolve model.universe }
      else
        model

    Actions actions ->
      List.foldl update model actions


start : Model -> Signal Model
start model =
  let
    modelSignal =
      Signal.map Actions actions.signal

    evolutionSignal =
      Signal.map Evolve (every 500)

    merged =
      Signal.merge modelSignal evolutionSignal
  in
    Signal.foldp unifiedUpdate model merged
