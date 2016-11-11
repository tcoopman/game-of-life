module View.Triangle exposing (left, right, up, down)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


(:=) =
    (,)


transparentBorder =
    "30px solid transparent"


solidBorder =
    "30px solid red"


sharedStyle =
    [ "margin" := "20px"
    , "width" := "0"
    , "height" := "0"
    ]


styledDiv : List ( String, String ) -> Html ()
styledDiv style' =
    div
        [ style style'
        , onClick ()
        ]
        []


left : Html ()
left =
    styledDiv leftStyle


right : Html ()
right =
    styledDiv rightStyle


down : Html ()
down =
    styledDiv downStyle


up : Html ()
up =
    styledDiv upStyle


leftStyle : List ( String, String )
leftStyle =
    sharedStyle
        ++ [ "border-top" := transparentBorder
           , "border-bottom" := transparentBorder
           , "border-right" := solidBorder
           ]


rightStyle : List ( String, String )
rightStyle =
    sharedStyle
        ++ [ "border-top" := transparentBorder
           , "border-bottom" := transparentBorder
           , "border-left" := solidBorder
           ]


upStyle : List ( String, String )
upStyle =
    sharedStyle
        ++ [ "border-right" := transparentBorder
           , "border-left" := transparentBorder
           , "border-bottom" := solidBorder
           ]


downStyle : List ( String, String )
downStyle =
    sharedStyle
        ++ [ "border-right" := transparentBorder
           , "border-left" := transparentBorder
           , "border-top" := solidBorder
           ]
