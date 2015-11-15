import Html exposing (Html)
import Types exposing (..)
import View exposing (..)
import GameOfLive

create : X -> Y -> Cell -> PositionedCell
create x y cell =
  ((Position x y), cell)

blinker : Universe
blinker =
  [ create 0 0 Dead
  , create 1 0 Dead
  , create 2 0 Dead
  , create 3 0 Dead
  , create 4 0 Dead
  , create 0 1 Dead
  , create 1 1 Alive
  , create 2 1 Alive
  , create 3 1 Alive
  , create 4 1 Dead
  , create 0 2 Dead
  , create 1 2 Dead
  , create 2 2 Dead
  , create 3 2 Dead
  , create 4 2 Dead
  ]

main : Signal Html
main =
  let
    viewPort = ViewPort 0 0 4 2
  in
    Signal.map (view viewPort) (GameOfLive.evolution blinker)
