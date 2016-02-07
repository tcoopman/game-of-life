module Main (..) where

import Html exposing (Html)
import Types exposing (..)
import View exposing (..)
import Start exposing (start, address)
import Examples exposing (glider)


init : Universe -> Model
init universe =
  { universe = universe
  , viewPort = ViewPort 0 0 20 20 35
  , running = True
  }


main : Signal Html
main =
  let
    model =
      init glider
  in
    Signal.map (view address) (Start.start model)
