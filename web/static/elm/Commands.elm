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

fetchElection id success failure =
  Http.get electionWrappedDecoder (fetchAllUrl id)
    |> Task.perform failure success

fetchAllUrl id =
  String.join "/" ["/api", "elections", (toString id)]

voteEntry candidate =
  object
    [ ("candidate_id", Encode.int candidate.id)
    , ("rank", Encode.int (Maybe.withDefault 0 candidate.rank))
    ]

isVotedFor candidate =
  case candidate.rank of
    Just x ->
      True
    Nothing ->
      False

voteEntries candidates =
  List.filter isVotedFor candidates
    |> List.map voteEntry

vote candidates =
    Encode.object
      [ ("vote", Encode.object
          [ ("vote_entries", Encode.list (voteEntries candidates)) ]
        )
      ]

postVote id candidates failure success =
  Http.send Http.defaultSettings
    { verb = "POST"
    , headers = [ ( "Content-Type", "application/json" ) ]
    , url = voteUrl id
    , body = candidates |> vote |> (encode 0) |> Http.string
    }
    |> Http.fromJson voteId
    |> Task.perform failure success

voteUrl id =
  String.join "/" ["/api", "elections", (toString id), "votes"]

voteId =
  Decode.at ["data", "id"] Decode.int

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
