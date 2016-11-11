module Start exposing (update)

import GameOfLife exposing (evolve)
import Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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
        let
            newModel =
                case msg of
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

                    Evolve ->
                        if model.running then
                            { model | universe = evolve model.universe }
                        else
                            model
        in
            ( newModel, Cmd.none )
