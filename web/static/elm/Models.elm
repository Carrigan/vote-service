module Models exposing (..)
import Http

type alias Candidate =
  { id : Int
  , name : String
  , rank : Maybe Int
  }

type alias Election =
  { candidates : List Candidate
  , id : Int
  , name : String
  , seat_count : Int
  , created_at : String
  }

type alias ElectionList =
  { data : List Election
  }

type alias ElectionWrapped =
  { data : Election
  }
