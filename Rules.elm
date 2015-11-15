module Rules (applyRules) where

import Types exposing (..)

numberOfLive : Neighbours -> Int
numberOfLive neighbours =
  neighbours
    |> List.filter ((==) Alive)
    |> List.length


-- Any live cell with fewer than two live neighbours dies, as if caused by under-population.
underPopulationRule : Cell -> Neighbours -> Action
underPopulationRule cell neighbours =
  case cell of
    Alive ->
      if numberOfLive neighbours < 2 then
        Dies
      else
        NoOp

    Dead ->
      NoOp

-- Any live cell with two or three live neighbours lives on to the next generation.
livesOnRule : Cell -> Neighbours -> Action
livesOnRule cell neighbours =
  case cell of
    Alive ->
      let
        numberOfLiveNeighbours = numberOfLive neighbours
      in
        if ((numberOfLiveNeighbours == 2) || (numberOfLiveNeighbours == 3)) then
          NoOp
        else
          Dies

    Dead ->
      NoOp

-- Any live cell with more than three live neighbours dies, as if by over-population.
overPopulationRule : Cell -> Neighbours -> Action
overPopulationRule cell neighbours =
  case cell of
    Alive ->
      if numberOfLive neighbours > 3 then
        Dies
      else
        NoOp

    Dead ->
      NoOp

-- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
reproductionRule : Cell -> Neighbours -> Action
reproductionRule cell neighbours =
  case cell of
    Alive ->
      NoOp

    Dead ->
      if numberOfLive neighbours == 3 then
        Revives
      else
        NoOp

reduceAction : Cell -> Neighbours -> Action
reduceAction cell neighbours =
  let
    actions =
      []
        |> (++) [underPopulationRule cell neighbours]
        |> (++) [livesOnRule cell neighbours]
        |> (++) [overPopulationRule cell neighbours]
        |> (++) [reproductionRule cell neighbours]
    reducedAction =
      actions
        |> List.filter ((/=) NoOp)
        |> List.head
  in
    Maybe.withDefault NoOp reducedAction


applyRules : Cell -> Neighbours -> Cell
applyRules cell neighbours =
  let
    action = reduceAction cell neighbours
  in
    case action of
      Dies -> Dead
      Revives -> Alive
      NoOp -> cell

applyRulesTest : List (Bool, String)
applyRulesTest =
-- Any live cell with fewer than two live neighbours dies, as if caused by under-population.
  [ ((applyRules Alive [Dead]) == Dead, "Underpopulation")
  , ((applyRules Alive [Alive, Alive, Dead]) == Alive, "Lives on with 2")
  , ((applyRules Alive [Alive, Alive, Alive, Alive]) == Dead, "Overpopulation")
  , ((applyRules Dead [Alive, Alive, Alive]) == Alive, "reproduction")
  , ((applyRules Dead [Dead,Dead,Dead,Alive,Alive,Alive]) == Alive, "reproduction")
  ]
