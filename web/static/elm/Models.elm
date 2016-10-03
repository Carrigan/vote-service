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
  }

type alias ElectionWrapped =
  { data : Election
  }
