module GameOfLife (evolution) where

import Rules exposing (applyRules)
import Types exposing (..)
import Time exposing (..)

findNeighbours : Universe -> X -> Y -> Neighbours
findNeighbours universe x y =
  let
    isNeighbour ((x', y'), _) =
      (abs (x' - x) <= 1)
      && (abs (y' - y) <= 1)
      && ((x,y) /= (x', y'))
  in
    universe
      |> List.filter isNeighbour
      |> List.map snd

evolveCell : Universe -> PositionedCell -> PositionedCell
evolveCell universe ((x, y), cell) =
  let
    neighbours = findNeighbours universe x y
    evolvedCell = applyRules cell neighbours
  in
    ((x, y), evolvedCell)

evolve : Universe -> Universe
evolve universe =
  let
    alwaysInt maybeInt = Maybe.withDefault 0 maybeInt
    minX = (universe |> List.map (fst << fst) |> List.minimum |> alwaysInt) - 1
    minY = (universe |> List.map (snd << fst) |> List.minimum |> alwaysInt) - 1
    maxX = (universe |> List.map (fst << fst) |> List.maximum |> alwaysInt) + 1
    maxY = (universe |> List.map (snd << fst) |> List.maximum |> alwaysInt) + 1
    createDeadX y x =
      ((x, y), Dead)
    createDeadY x y =
      ((x, y), Dead)
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
    Signal.foldp evolver universe (every 9000)
