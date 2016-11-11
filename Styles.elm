module Styles exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import Html.CssHelpers exposing (withNamespace)


type CssClasses
    = Cell
    | DeadCell
    | LiveCell


cellNamespace =
    withNamespace "cell"


blue =
    (rgb 52 152 219)


green =
    (rgb 46 204 113)


red =
    (rgb 231 76 60)


yellow =
    (rgb 241 196 14)


orange =
    (rgb 230 126 34)


purple =
    (rgb 137 96 158)


gray =
    (rgb 189 195 199)


asphalt =
    (rgb 52 73 94)


pink =
    (rgb 255 91 236)


css =
    (stylesheet << namespace cellNamespace.name)
        [ html [ height (vh 100) ]
        , body
            [ height (vh 100)
            , backgroundColor asphalt
            , color gray
            ]
        , ((.) Cell)
            [ flex auto
            , alignItems center
            , border3 (px 1) solid (rgb 203 203 203)
            ]
        , ((.) DeadCell)
            [ color asphalt
            , backgroundColor gray
            ]
        , ((.) LiveCell)
            [ color purple
            , backgroundColor red
            ]
        ]
