module View exposing (view)

import Html exposing (..)
import Html.App exposing (map)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on, targetValue)
import Types exposing (..)
import GameOfLife exposing (findCell)
import View.Triangle as Triangle
import View.PlayButton as PlayButton
import Styles exposing (..)
import Json.Decode as Json


{ id, class, classList } =
    cellNamespace
(:=) =
    (,)


sort : List PositionedCell -> List PositionedCell
sort positions =
    let
        sorter ( ( x1, y1 ), _ ) ( ( x2, y2 ), _ ) =
            if (x1 == x2) then
                compare y1 y2
            else
                compare x1 x2
    in
        List.sortWith sorter positions


selectRow : Universe -> ViewPort -> List PositionedCell
selectRow universe viewPort =
    [viewPort.xMin..viewPort.xMax]
        |> List.map ((,) viewPort.yMin)
        |> List.map (findCell universe)


viewRow : Universe -> ViewPort -> Html msg
viewRow universe viewPort =
    let
        row =
            selectRow universe viewPort

        cellSize =
            viewPort.cellSize
    in
        div [ style [ ( "display", "flex" ) ] ]
            (List.map (viewCell cellSize) row)


viewCell : Int -> PositionedCell -> Html msg
viewCell size ( ( x, y ), cell ) =
    div
        [ classList [ ( Cell, True ), ( LiveCell, cell == Alive ), ( DeadCell, cell == Dead ) ]
        , style <| cellSize cell size
        ]
        [ text ((toString x) ++ "," ++ (toString y)) ]


view : Model -> Html Msg
view model =
    let
        playLabel =
            if model.running then
                "Pause"
            else
                "Play"

        selectOption ( name, _ ) =
            option [] [ text name ]
    in
        div
            [ style
                [ "display" := "flex"
                , "flex-direction" := "column"
                , "align-items" := "center"
                ]
            ]
            [ map (\_ -> ToggleRunning) (PlayButton.button playLabel)
            , map (\_ -> ZoomOut) (PlayButton.button "Zoom out")
            , map (\_ -> ZoomIn) (PlayButton.button "Zoom in")
            , select [ on "change" (Json.map UpdateUniverse targetValue) ]
                (List.map selectOption model.examples)
            , map (\_ -> Up) Triangle.up
            , div
                [ style
                    [ "display" := "flex"
                    , "flex-direction" := "row"
                    , "align-items" := "center"
                    ]
                ]
                [ map (\_ -> Left) Triangle.left
                , viewUniverse model.viewPort model.universe
                , map (\_ -> Right) Triangle.right
                ]
            , map (\_ -> Down) Triangle.down
            ]


viewUniverse : ViewPort -> Universe -> Html msg
viewUniverse viewPort universe =
    let
        rowsRange =
            [viewPort.yMin..viewPort.yMax]

        rowViewPort row =
            ViewPort viewPort.xMin row viewPort.xMax row viewPort.cellSize

        rowsViewPort =
            List.map rowViewPort rowsRange

        rowsHtml =
            List.map (viewRow universe) rowsViewPort
    in
        div []
            rowsHtml


cellSize : Cell -> Int -> List ( String, String )
cellSize cell size =
    let
        cellSize =
            (toString size) ++ "px"
    in
        [ "width" := cellSize
        , "height" := cellSize
        , "font-size" := ((toString (size // 3)) ++ "px")
        ]
