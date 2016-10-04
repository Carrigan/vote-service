module Commands exposing (..)

import Models exposing (..)
import String
import Http

import Json.Decode as Decode
import Json.Decode exposing (Decoder, list, at)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Json.Encode as Encode
import Json.Encode exposing (encode, object, array)
import Task

-- GET /api/elections/:id --

fetchElection id success failure =
  Http.get electionWrappedDecoder (fetchElectionUrl id)
    |> Task.perform failure success

fetchElectionUrl id =
  String.join "/" ["/api", "elections", (toString id)]

electionWrappedDecoder =
  decode ElectionWrapped
    |> required "data" electionDecoder

electionDecoder =
  decode Election
    |> required "candidates" (Decode.list candidateDecoder)
    |> required "id" Decode.int

candidateDecoder =
  decode Candidate
    |> required "id" Decode.int
    |> required "name" Decode.string
    |> hardcoded Nothing

-- POST /api/elections --

postVote id candidates failure success =
  Http.send Http.defaultSettings
    { verb = "POST"
    , headers = [ ( "Content-Type", "application/json" ) ]
    , url = voteUrl id
    , body = candidates |> voteObject |> (encode 0) |> Http.string
    }
    |> Http.fromJson voteIdDecoder
    |> Task.perform failure success


voteUrl id =
  String.join "/" ["/api", "elections", (toString id), "votes"]

voteIdDecoder =
  Decode.at ["data", "id"] Decode.int

voteObject candidates =
    Encode.object
      [ ("vote", Encode.object
          [
            ("vote_entries", Encode.list (voteEntries candidates))
          ]
        )
      ]

voteEntries candidates =
  List.filter isVotedFor candidates
    |> List.map voteEntry

isVotedFor candidate =
  case candidate.rank of
    Just x ->
      True
    Nothing ->
      False

voteEntry candidate =
  object
    [ ("candidate_id", Encode.int candidate.id)
    , ("rank", Encode.int (Maybe.withDefault 0 candidate.rank))
    ]
