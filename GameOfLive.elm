module GameOfLive (evolution) where

import Rules exposing (applyRules)
import Types exposing (..)
import Time exposing (..)

findNeighbours : Universe -> X -> Y -> Neighbours
findNeighbours universe x y =
  let
    isNeighbour (position, _) =
      (position.x == x - 1 || position.x == x + 1 || position.x == x)
      &&
      (position.y == y - 1 || position.y == y + 1 || position.y == y)
      &&
      (position.x /= x || position.y /= y)
  in
    universe
      |> List.filter isNeighbour
      |> List.map snd

evolveCell : Universe -> PositionedCell -> PositionedCell
evolveCell universe (position, cell) =
  let
    neighbours = findNeighbours universe position.x position.y
    evolvedCell = applyRules cell neighbours
  in
    (position, evolvedCell)

evolve : Universe -> Universe
evolve universe =
  let
    alwaysInt maybeInt = Maybe.withDefault 0 maybeInt
    minX = (universe |> List.map (.x << fst) |> List.minimum |> alwaysInt) - 1
    minY = (universe |> List.map (.x << fst) |> List.minimum |> alwaysInt) - 1
    maxX = (universe |> List.map (.x << fst) |> List.maximum |> alwaysInt) + 1
    maxY = (universe |> List.map (.x << fst) |> List.maximum |> alwaysInt) + 1
    createDeadX y x =
      ((Position x y), Dead)
    createDeadY x y =
      ((Position x y), Dead)
    expandedUniverse =
      universe
        |> (++) (List.map (createDeadX minY) [minX .. maxX])
        |> (++) (List.map (createDeadX maxY) [minX .. maxX])
        |> (++) (List.map (createDeadY minX) [minY + 1 .. maxY - 1])
        |> (++) (List.map (createDeadY maxX) [minY + 1 .. maxY - 1])
  in
    List.map (evolveCell expandedUniverse) expandedUniverse

evolution : Universe -> Signal Universe
evolution universe =
  let
    evolver _ universe =
      evolve universe
  in
    Signal.foldp evolver universe (every 3000)
