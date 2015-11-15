module Types where

type Cell = Alive | Dead
type alias Neighbours = List Cell

type Action = Dies | Revives | NoOp

type alias X = Int
type alias Y = Int

type alias PositionedCell =
  { x: X
  , y: Y
  , cell: Cell
  }

type alias Universe = List PositionedCell
