module View.PlayButton exposing (button)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


(:=) =
    (,)


buttonStyle : List ( String, String )
buttonStyle =
    [ "color" := "red"
    , "font-size" := "2em"
    ]


button : String -> Html ()
button label =
    div
        [ style buttonStyle
        , onClick ()
        ]
        [ text label ]
