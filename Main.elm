module Main exposing (..)

import Html exposing (Html)
import Types exposing (..)
import View exposing (..)
import Start
import Examples exposing (glider, all)
import Time exposing (millisecond)


init : Universe -> Model
init universe =
    { universe = universe
    , examples = Examples.all
    , viewPort = ViewPort 0 0 20 20 35
    , running = True
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.running then
        Time.every (200 * millisecond) (\_ -> Evolve)
    else
        Sub.none


main =
    let
        model =
            init glider
    in
        Html.program
            { init = ( init glider, Cmd.none )
            , view = view
            , update = Start.update
            , subscriptions = subscriptions
            }
