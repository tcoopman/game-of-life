import Html exposing (Html)
import Types exposing (..)
import View exposing (..)
import GameOfLife exposing (evolve)
import Time exposing (..)

create : List Position-> Universe
create positions =
  let
    positionedCell position = (position, Alive)
  in
  List.map positionedCell positions

blinker : Universe
blinker = create [(1, 1), (2, 1), (3, 1)]

spaceShip : Universe
spaceShip = create [(2, 0), (0, 1), (2, 1), (1, 2), (2, 2)]

pulsar : Universe
pulsar =
  create
  [ (4, 2), (5, 2), (6, 2), (10, 2), (11, 2), (12, 2)
  , (2, 4), (7, 4), (9, 4), (14, 4)
  , (2, 5), (7, 5), (9, 5), (14, 5)
  , (2, 6), (7, 6), (9, 6), (14, 6)
  , (4, 7), (5, 7), (6, 7), (10, 7), (11, 7), (12, 7)
  , (4, 9), (5, 9), (6, 9), (10, 9), (11, 9), (12, 9)
  , (2, 10), (7, 10), (9, 10), (14, 10)
  , (2, 11), (7, 11), (9, 11), (14, 11)
  , (2, 12), (7, 12), (9, 12), (14, 12)
  , (4, 14), (5, 14), (6, 14), (10, 14), (11, 14), (12, 14)
  ]

actions : Signal.Mailbox (List Action)
actions = Signal.mailbox []

singleton : Action -> List Action
singleton action = [action]

address : Signal.Address Action
address = Signal.forwardTo actions.address singleton

init : Universe -> Model
init universe =
  { universe = universe
  , viewPort = ViewPort 0 0 16 16
  , running = True
  }

update : Action -> Model -> Model
update action model =
  let
    xMin = model.viewPort.xMin
    yMin = model.viewPort.yMin
    xMax = model.viewPort.xMax
    yMax = model.viewPort.yMax
  in
    case action of
      NoOp  -> model
      ToggleRunning -> { model | running <- not model.running }
      Up    -> { model | viewPort <- ViewPort xMin (yMin - 1) xMax (yMax - 1)}
      Down  -> { model | viewPort <- ViewPort xMin (yMin + 1) xMax (yMax + 1)}
      Left  -> { model | viewPort <- ViewPort (xMin - 1 ) yMin (xMax - 1) yMax}
      Right -> { model | viewPort <- ViewPort (xMin + 1 ) yMin (xMax + 1) yMax}

unifiedUpdate : Message -> Model -> Model
unifiedUpdate message model =
  case message of
    Evolve _ ->
      if model.running then
        { model | universe <- evolve model.universe}
      else
        model
    Actions actions -> List.foldl update model actions

type Message = Actions (List Action) | Evolve Float

main : Signal Html
main =
  let
    model = init pulsar
    modelSignal = Signal.map Actions actions.signal
    evolutionSignal = Signal.map Evolve (every 1000)
    merged = Signal.merge modelSignal evolutionSignal
    past = Signal.foldp unifiedUpdate model merged
  in
    Signal.map (view address) past
