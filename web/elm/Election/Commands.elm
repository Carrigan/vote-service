module Election.Commands exposing (..)

import Election.Messages exposing (..)
import Json.Encode as Encode
import Http
import Task

createElection election =
  Task.perform CreateElectionFailure CreateElectionSuccess (electionPost election)

electionPost election =
  let
    url = "/api/elections"
    candidateSerializer candidate =
      Encode.object [("name", Encode.string candidate.name)]
    object = Encode.object
      [ ("name", Encode.string election.name)
      , ("seats", Encode.int election.seats)
      , ("candidates", Encode.list (List.map candidateSerializer election.candidates))
      ]
    body = Encode.encode 2 (Encode.object [("election", object)])
  in
    Http.send
      Http.defaultSettings
      { verb = "POST"
      , headers = [("Content-Type", "application/json")]
      , url = url
      , body = (Http.string body)
      }
