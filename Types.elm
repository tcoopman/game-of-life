module Types where

type Cell = Alive | Dead
type alias Neighbours = List Cell

type Action = Dies | Revives | NoOp

type alias X = Int
type alias Y = Int

type alias Position = (X, Y)

type alias PositionedCell = (Position, Cell)

type alias Universe = List PositionedCell

type alias ViewPort =
  { xMin: X
  , yMin: Y
  , xMax: X
  , yMax: Y
  }

type alias Model =
  { universe: Universe
  , viewPort: ViewPort
  }
