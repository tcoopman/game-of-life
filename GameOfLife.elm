module GameOfLife (evolution) where

import Rules exposing (applyRules)
import Types exposing (..)
import Time exposing (..)
import Set exposing (..)

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

findPositionedCell : Universe -> Position -> Maybe PositionedCell
findPositionedCell universe (x, y) =
  let
    inBounds ((x', y'), _) = x' == x && y' == y
  in
    universe
      |> List.filter inBounds
      |> List.head

findCellOrCreateDead : Universe -> Position -> PositionedCell
findCellOrCreateDead universe position =
  case findPositionedCell universe position of
    Nothing -> (position, Dead)
    Just (_, cell) -> (position, cell)

dropDuplicates : List comparable -> List comparable
dropDuplicates list =
  let
    step next (set, acc) =
      if Set.member next set
        then (set, acc)
        else (Set.insert next set, next::acc)
  in
    List.foldl step (Set.empty, []) list |> snd |> List.reverse

dedupe : Universe-> Universe
dedupe universe =
  let
    positions = List.map fst universe
    dedupedPositions =
      positions
        |> Set.fromList |> Set.toList
  in
    List.map (findCellOrCreateDead universe) dedupedPositions

evolve : Universe -> Universe
evolve universe =
  let
    otherPositions (x, y) = [(x-1, y-1), (x, y-1), (x+1, y-1), (x-1, y), (x+1, y), (x-1, y+1), (x, y+1), (x+1, y+1)]
    cells position = List.map (findCellOrCreateDead universe) (otherPositions position)
    currentUniverse =
      universe
        |> List.map fst
        |> List.map cells
        |> List.concat
        |> dedupe
  in
    currentUniverse
      |> List.map (evolveCell universe)
      |> List.filter ((==) Alive << snd)

evolution : Universe -> Signal Universe
evolution universe =
  let
    evolver _ universe =
      evolve universe
  in
    Signal.foldp evolver universe (every 500)
