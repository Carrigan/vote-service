module Commands exposing (..)

import Models exposing (..)
import String
import Http

import Json.Decode exposing (int, string, float, Decoder, (:=), list)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)

import Task

fetchElection id success failure =
  Http.get electionWrappedDecoder (fetchAllUrl id)
    |> Task.perform failure success

fetchAllUrl id =
  String.join "/" ["/api", "elections", (toString id)]

electionWrappedDecoder =
  decode ElectionWrapped
    |> required "data" electionDecoder

electionDecoder =
  decode Election
    |> required "candidates" (list candidateDecoder)

candidateDecoder =
  decode Candidate
    |> required "id" int
    |> required "name" string
    |> hardcoded Nothing
