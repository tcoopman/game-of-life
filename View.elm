module View (ViewPort, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import GameOfLife exposing (findCell)
import View.Triangle as Triangle

(:=) = (,)

type alias ViewPort =
  { xMin: X
  , yMin: Y
  , xMax: X
  , yMax: Y
  }

sort : List PositionedCell -> List PositionedCell
sort positions =
  let
    sorter ((x1, y1), _) ((x2, y2), _) =
      if (x1 == x2) then
        compare y1 y2
      else
        compare x1 x2
  in
    List.sortWith sorter positions

selectRow : Universe -> ViewPort -> List PositionedCell
selectRow universe viewPort =
  [viewPort.xMin .. viewPort.xMax]
    |> List.map ((,) viewPort.yMin)
    |> List.map (findCell universe)

viewRow : Universe -> ViewPort -> Html
viewRow universe viewPort =
  let
    row = selectRow universe viewPort
  in
    div
      [ style [("display", "flex")] ]
      (List.map viewCell row)

viewCell : PositionedCell -> Html
viewCell ((x, y), cell) =
  div
    [style <| cellStyle cell]
    [ text ((toString x) ++ "," ++(toString y))]



view : ViewPort -> Universe -> Html
view viewPort universe =
  div
    [ style
      [ "display" := "flex"
      , "flex-direction" := "column"
      , "align-items" := "center"
      ]
    ]
    [ Triangle.up
    , div
        [ style
          [ "display" := "flex"
          , "flex-direction" := "row"
          , "align-items" := "center"
          ]
        ]
        [ Triangle.left
        , viewUniverse viewPort universe
        , Triangle.right
        ]
    , Triangle.down
    ]

viewUniverse : ViewPort -> Universe -> Html
viewUniverse viewPort universe =
  let
    rowsRange = [viewPort.yMin .. viewPort.yMax]
    rowViewPort row = ViewPort viewPort.xMin row viewPort.xMax row
    rowsViewPort = List.map rowViewPort rowsRange
    rowsHtml = List.map (viewRow universe) rowsViewPort
  in
    div
      []
      rowsHtml

cellStyle : Cell -> List (String, String)
cellStyle cell =
  let
    color =
      case cell of
        Alive -> "red"
        Dead -> "gray"
  in
    [ "width" := "35px"
    , "height" := "35px"
    , "font-size" := "0.9em"
    , "background" := color
    , "border" := "1px solid gray"
    , "color" := "rgb(59, 51, 55)"
    ]
