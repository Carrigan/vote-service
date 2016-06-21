module Election.Update exposing (..)

import Election.Models exposing (newElection, newCandidate)
import Election.Messages exposing (..)
import Election.Commands exposing (createElection)
import String

update msg election =
  case msg of
    NoOp ->
      election ! []

    ElectionName string ->
      { election | name = string } ! []

    SeatCount string ->
      case String.toInt string of
        Err str ->   election ! []
        Ok n      -> { election | seats = n } ! []

    EditCandidate candidate_id string ->
      let
        updateCandidate c =
          if c.id == candidate_id then { c | name = string } else c
      in
        { election | candidates = List.map updateCandidate election.candidates }
        ! []

    AddCandidate ->
      let
        newId = election.currentId + 1

      in
        { election | candidates = List.append election.candidates [(newCandidate newId)]
                    , currentId = newId }
        ! []

    CreateElection ->
      (election, createElection election)


    CreateElectionSuccess resp ->
      election ! []

    CreateElectionFailure err ->
      election ! []
