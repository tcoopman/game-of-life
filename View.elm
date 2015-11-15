module View (ViewPort, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)

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

findPositionedCell : Universe -> Position -> Maybe PositionedCell
findPositionedCell universe (x, y) =
  let
    inBounds ((x', y'), _) = x' == x && y' == y
  in
    universe
      |> List.filter inBounds
      |> List.head

findCellOrCreateDead : Universe -> Position -> Cell
findCellOrCreateDead universe position =
  case findPositionedCell universe position of
    Nothing -> Dead
    Just (_, cell) -> cell

selectRow : Universe -> ViewPort -> List PositionedCell
selectRow universe viewPort =
  let
    findPositionedCell y x =
      ((x, y), findCellOrCreateDead universe (x, y))
  in
  [viewPort.xMin .. viewPort.xMax]
    |> List.map (findPositionedCell viewPort.yMin)

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
    (:=) = (,)
    color =
      case cell of
        Alive -> "red"
        Dead -> "gray"
  in
    [ "width" := "30px"
    , "height" := "30px"
    , "background" := color
    , "border" := "1px solid gray"
    ]
