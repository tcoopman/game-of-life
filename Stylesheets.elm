port module Stylesheets exposing (..)

import Css.File exposing (..)
import Html.App as App
import Html exposing (div)
import Styles exposing (css)


port files : CssFileStructure -> Cmd msg


cssFiles : CssFileStructure
cssFiles =
    toFileStructure [ ( "main.css", compile [ css ] ) ]


main : Program Never
main =
    App.program
        { init = ( (), files cssFiles )
        , view = \_ -> (div [] [])
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        }
