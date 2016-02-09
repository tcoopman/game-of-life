module Rules (applyRules) where

import Types exposing (..)


numberOfLive : Neighbours -> Int
numberOfLive neighbours =
  neighbours
    |> List.filter ((==) Alive)
    |> List.length



-- Any live cell with fewer than two live neighbours dies, as if caused by under-population.


underPopulationRule : Cell -> Neighbours -> LifeCycle
underPopulationRule cell neighbours =
  case cell of
    Alive ->
      if numberOfLive neighbours < 2 then
        Dies
      else
        Same

    Dead ->
      Same



-- Any live cell with two or three live neighbours lives on to the next generation.


livesOnRule : Cell -> Neighbours -> LifeCycle
livesOnRule cell neighbours =
  case cell of
    Alive ->
      let
        numberOfLiveNeighbours =
          numberOfLive neighbours
      in
        if ((numberOfLiveNeighbours == 2) || (numberOfLiveNeighbours == 3)) then
          Same
        else
          Dies

    Dead ->
      Same



-- Any live cell with more than three live neighbours dies, as if by over-population.


overPopulationRule : Cell -> Neighbours -> LifeCycle
overPopulationRule cell neighbours =
  case cell of
    Alive ->
      if numberOfLive neighbours > 3 then
        Dies
      else
        Same

    Dead ->
      Same



-- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.


reproductionRule : Cell -> Neighbours -> LifeCycle
reproductionRule cell neighbours =
  case cell of
    Alive ->
      Same

    Dead ->
      if numberOfLive neighbours == 3 then
        Revives
      else
        Same


reduceLifeCycle : Cell -> Neighbours -> LifeCycle
reduceLifeCycle cell neighbours =
  let
    actions =
      [ underPopulationRule cell neighbours
      , livesOnRule cell neighbours
      , overPopulationRule cell neighbours
      , reproductionRule cell neighbours
      ]

    reducedLifeCycle =
      actions
        |> List.filter ((/=) Same)
        |> List.head
  in
    Maybe.withDefault Same reducedLifeCycle


applyRules : Cell -> Neighbours -> Cell
applyRules cell neighbours =
  let
    action =
      reduceLifeCycle cell neighbours
  in
    case action of
      Dies ->
        Dead

      Revives ->
        Alive

      Same ->
        cell


applyRulesTest : List ( Bool, String )
applyRulesTest =
  -- Any live cell with fewer than two live neighbours dies, as if caused by under-population.
  [ ( (applyRules Alive [ Dead ]) == Dead, "Underpopulation" )
  , ( (applyRules Alive [ Alive, Alive, Dead ]) == Alive, "Lives on with 2" )
  , ( (applyRules Alive [ Alive, Alive, Alive, Alive ]) == Dead, "Overpopulation" )
  , ( (applyRules Dead [ Alive, Alive, Alive ]) == Alive, "reproduction" )
  , ( (applyRules Dead [ Dead, Dead, Dead, Alive, Alive, Alive ]) == Alive, "reproduction" )
  ]
