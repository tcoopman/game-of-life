module View.Triangle (left, right, up, down) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

(:=) = (,)

transparentBorder = "30px solid transparent"
solidBorder = "30px solid red"

sharedStyle =
  [ "margin" := "20px"
  , "width" := "0"
  , "height" := "0"
  ]

styledDiv : Signal.Address () -> List (String, String) -> Html
styledDiv address style' =
  div
    [ style style'
    , onClick address ()
    ] []

left : Signal.Address () -> Html
left address = styledDiv address leftStyle

right : Signal.Address () -> Html
right address = styledDiv address rightStyle

down : Signal.Address () -> Html
down address = styledDiv address downStyle

up : Signal.Address () -> Html
up address = styledDiv address upStyle

leftStyle : List (String, String)
leftStyle =
  sharedStyle ++
  [ "border-top" := transparentBorder
  , "border-bottom" := transparentBorder
  , "border-right" := solidBorder
  ]

rightStyle : List (String, String)
rightStyle =
  sharedStyle ++
  [ "border-top" := transparentBorder
  , "border-bottom" := transparentBorder
  , "border-left" := solidBorder
  ]

upStyle : List (String, String)
upStyle =
  sharedStyle ++
  [ "border-right" := transparentBorder
  , "border-left" := transparentBorder
  , "border-bottom" := solidBorder
  ]

downStyle : List (String, String)
downStyle =
  sharedStyle ++
  [ "border-right" := transparentBorder
  , "border-left" := transparentBorder
  , "border-top" := solidBorder
  ]
