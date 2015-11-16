module View.PlayButton (button) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

(:=) = (,)

buttonStyle : List (String, String)
buttonStyle =
  [ "color" := "red"
  , "font-size" := "2em"
  ]

button : String -> Signal.Address () -> Html
button label address =
  div
    [ style buttonStyle
    , onClick address () ]
    [ text label ]
