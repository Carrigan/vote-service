module Election.Models exposing (..)

type alias Candidate =
  { name : String
  , id : Int
  }

type alias Election =
  { candidates : List Candidate
  , name : String
  , seats : Int
  , currentId : Int
  }

newElection : Election
newElection =
  { candidates = [newCandidate 0]
  , name = ""
  , seats = 1
  , currentId = 0
  }

newCandidate : Int -> Candidate
newCandidate id =
  { name = ""
  , id = id
  }
