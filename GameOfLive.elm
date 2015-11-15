module GameOfLive (evolution) where

import Rules exposing (applyRules)
import Types exposing (..)
import Time exposing (..)

findNeighbours : Universe -> X -> Y -> Neighbours
findNeighbours universe x y =
  let
    isNeighbour positionedCell =
      (positionedCell.x == x - 1 || positionedCell.x == x + 1 || positionedCell.x == x)
      &&
      (positionedCell.y == y - 1 || positionedCell.y == y + 1 || positionedCell.y == y)
      &&
      (positionedCell.x /= x || positionedCell.y /= y)
  in
    universe
      |> List.filter isNeighbour
      |> List.map .cell

evolveCell : Universe -> PositionedCell -> PositionedCell
evolveCell universe positionedCell =
  let
    neighbours = findNeighbours universe positionedCell.x positionedCell.y
  in
    { positionedCell
      | cell <- applyRules positionedCell.cell neighbours
    }

newRow : List PositionedCell
newRow =
  let
    create y x =
      PositionedCell x y Dead
  in
    List.map (create 1) [1 .. 2]

evolve : Universe -> Universe
evolve universe =
  let
    alwaysInt maybeInt = Maybe.withDefault 0 maybeInt
    minX = (universe |> List.map .x |> List.minimum |> alwaysInt) - 1
    minY = (universe |> List.map .y |> List.minimum |> alwaysInt) - 1
    maxX = (universe |> List.map .x |> List.maximum |> alwaysInt) + 1
    maxY = (universe |> List.map .y |> List.maximum |> alwaysInt) + 1
    createDeadX y x =
      PositionedCell x y Dead
    createDeadY x y =
      PositionedCell x y Dead
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
