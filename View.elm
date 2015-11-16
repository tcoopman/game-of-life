module View (view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import GameOfLife exposing (findCell)
import View.Triangle as Triangle

(:=) = (,)

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



view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ style
      [ "display" := "flex"
      , "flex-direction" := "column"
      , "align-items" := "center"
      ]
    ]
    [ Triangle.up (Signal.forwardTo address (\_ -> Up))
    , div
        [ style
          [ "display" := "flex"
          , "flex-direction" := "row"
          , "align-items" := "center"
          ]
        ]
        [ Triangle.left (Signal.forwardTo address (\_ -> Left))
        , viewUniverse model.viewPort model.universe
        , Triangle.right (Signal.forwardTo address (\_ -> Right))
        ]
    , Triangle.down (Signal.forwardTo address (\_ -> Down))
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
    background =
      case cell of
        Alive -> "red"
        Dead -> "rgb(180, 180, 180)"
    color =
      case cell of
        Alive -> "rgb(40, 33, 33)"
        Dead -> "rgb(120, 120, 120)"

  in
    [ "width" := "35px"
    , "height" := "35px"
    , "font-size" := "0.7em"
    , "display" := "flex"
    , "justify-content" := "center"
    , "align-items" := "center"
    , "background" := background
    , "border" := "1px solid rgb(203, 203, 203)"
    , "color" := color
    ]
