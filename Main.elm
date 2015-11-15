import Html exposing (Html)
import Types exposing (..)
import View exposing (..)
import GameOfLive

blinker : Universe
blinker =
  [ PositionedCell 0 0 Dead
  , PositionedCell 1 0 Dead
  , PositionedCell 2 0 Dead
  , PositionedCell 3 0 Dead
  , PositionedCell 4 0 Dead
  , PositionedCell 0 1 Dead
  , PositionedCell 1 1 Alive
  , PositionedCell 2 1 Alive
  , PositionedCell 3 1 Alive
  , PositionedCell 4 1 Dead
  , PositionedCell 0 2 Dead
  , PositionedCell 1 2 Dead
  , PositionedCell 2 2 Dead
  , PositionedCell 3 2 Dead
  , PositionedCell 4 2 Dead
  ]

main : Signal Html
main =
  let
    viewPort = ViewPort 0 0 4 2
  in
    Signal.map (view viewPort) (GameOfLive.evolution blinker)
