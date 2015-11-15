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

selectRow : Universe -> ViewPort -> List PositionedCell
selectRow universe viewPort =
  let
    inBounds (position, _) =
      position.y == viewPort.yMin
      && position.x >= viewPort.xMin
      && position.x <= viewPort.xMax
  in
    List.filter inBounds universe


viewRow : Universe -> ViewPort -> Html
viewRow universe viewPort =
  let
    row = selectRow universe viewPort
  in
    div
      [ style [("display", "flex")] ]
      (List.map viewCell row)

viewCell : PositionedCell -> Html
viewCell (position, cell) =
  div
    [style <| cellStyle cell]
    [ text ((toString position.x) ++ "," ++(toString position.y))]

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
    color =
      case cell of
        Alive -> "red"
        Dead -> "gray"
  in
    []
      |> (++) [("width", "30px")]
      |> (++) [("height", "30px")]
      |> (++) [("background", color)]
      |> (++) [("border", "1px solid gray")]
