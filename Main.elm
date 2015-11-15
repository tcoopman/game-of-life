import Html exposing (Html)
import Types exposing (..)
import View exposing (..)
import GameOfLife exposing (evolution)

create : List Position-> Universe
create positions =
  let
    positionedCell position = (position, Alive)
  in
  List.map positionedCell positions

blinker : Universe
blinker = create [(1, 1), (2, 1), (3, 1)]

spaceShip : Universe
spaceShip = create [(2, 0), (0, 1), (2, 1), (1, 2), (2, 2)]

main : Signal Html
main =
  let
    viewPort = ViewPort 0 0 10 10
  in
    Signal.map (view viewPort) (evolution blinker)
