module FromPlainText (toUniverse) where

import Types exposing (..)
import String


toPosition : Int -> Int -> Char -> PositionedCell
toPosition x y char =
  case char of
    'O' ->
      ( ( x, y ), Alive )

    _ ->
      ( ( x, y ), Dead )


lineToUniverse : Int -> String -> List PositionedCell
lineToUniverse x string =
  let
    chars =
      String.toList string
  in
    List.indexedMap (toPosition x) chars


toUniverse : String -> Universe
toUniverse str =
  let
    lines =
      String.lines str
  in
    List.concat (List.indexedMap lineToUniverse lines)
