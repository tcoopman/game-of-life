module Types (..) where


type Cell
  = Alive
  | Dead


type alias Neighbours =
  List Cell


type LifeCycle
  = Dies
  | Revives
  | Same


type alias X =
  Int


type alias Y =
  Int


type alias Position =
  ( X, Y )


type alias PositionedCell =
  ( Position, Cell )


type alias Universe =
  List PositionedCell


type alias ViewPort =
  { xMin : X
  , yMin : Y
  , xMax : X
  , yMax : Y
  , cellSize : Int
  }


type alias Model =
  { universe : Universe
  , viewPort : ViewPort
  , running : Bool
  }


type Action
  = NoOp
  | ToggleRunning
  | ZoomOut
  | ZoomIn
  | Left
  | Right
  | Down
  | Up
