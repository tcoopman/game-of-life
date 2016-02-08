module Stylesheets (..) where

import Css.File exposing (..)
import Styles exposing (css)

port files : CssFileStructure
port files =
  toFileStructure
    [ ( "main.css", compile css) ]
