module GameOfLife (evolution, findCell) where

import Rules exposing (applyRules)
import Types exposing (..)
import Time exposing (..)
import Set exposing (..)

isNeighbour : Position -> Position -> Bool
isNeighbour (x1, y1) (x2, y2) =
  (abs (x1 - x2) <= 1)
  && (abs (y1 - y2) <= 1)
  && ((x1, y1) /= (x2, y2))

findNeighbours : Universe -> Position -> Neighbours
findNeighbours universe position =
  universe
    |> List.filter (isNeighbour position << fst)
    |> List.map snd

evolveCell : Universe -> PositionedCell -> PositionedCell
evolveCell universe (position, cell) =
  let
    neighbours = findNeighbours universe position
    evolvedCell = applyRules cell neighbours
  in
    (position, evolvedCell)

findMaybeCell : Universe -> Position -> Maybe PositionedCell
findMaybeCell universe (x, y) =
  let
    inBounds ((x', y'), _) = x' == x && y' == y
  in
    universe
      |> List.filter inBounds
      |> List.head

findCell : Universe -> Position -> PositionedCell
findCell universe position =
  case findMaybeCell universe position of
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
    List.map (findCell universe) dedupedPositions

evolve : Universe -> Universe
evolve universe =
  let
    otherPositions (x, y) = [(x-1, y-1), (x, y-1), (x+1, y-1), (x-1, y), (x+1, y), (x-1, y+1), (x, y+1), (x+1, y+1)]
    cells position = List.map (findCell universe) (otherPositions position)
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
  Signal.foldp (\_ -> evolve) universe (every 500)
