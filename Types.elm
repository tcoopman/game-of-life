module Types where

type Cell = Alive | Dead
type alias Neighbours = List Cell

type Action = Dies | Revives | NoOp

type alias X = Int
type alias Y = Int

type alias Position =
  { x: X
  , y: Y
  }

type alias PositionedCell =
  { position: Position
  , cell: Cell
  }

type alias Universe = List PositionedCell
