port module Vote exposing (..)

import Http
import Html exposing (Html, button, div, text, h3, ul, li, span)
import Html.App as App
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import String

import Commands exposing (fetchElection, postVote)
import Models exposing (..)

type Msg
  = Select Candidate
  | Vote
  | FetchElectionSuccess ElectionWrapped
  | FetchElectionFailure Http.Error
  | VotePostSuccess Int
  | VotePostFailure Http.Error

-- Main Application --

main =
    App.programWithFlags
        { init = initialState
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

port voteComplete : Int -> Cmd msg


-- Initialization --

initialState : String -> ( Election, Cmd Msg )
initialState electionString =
  case String.toInt electionString of
    Ok electionId ->
      ({ id = 0, candidates = [] }, fetchElection electionId FetchElectionSuccess FetchElectionFailure)
    Err _ ->
      { id = 0, candidates = [] } ! []

-- Subscriptions --

subscriptions model =
    Sub.none

-- Update State --

update : Msg -> Election -> ( Election, Cmd Msg )
update msg model =
  case msg of
    Select candidate ->
      let
        candidates = model.candidates
      in
        { model | candidates = (List.map (updateSelect candidate (highestRank candidates)) candidates) } ! []

    Vote ->
      if (enabled model.candidates) then
        (model, postVote model.id model.candidates VotePostFailure VotePostSuccess)
      else
        model ! []

    FetchElectionSuccess wrappedElection ->
      wrappedElection.data ! []

    FetchElectionFailure error ->
      model ! []

    VotePostSuccess voteId ->
      (model, voteComplete 0)

    VotePostFailure error ->
      model ! []

replaceHigherRank : Candidate -> Int -> Int
replaceHigherRank candidate highest =
  case candidate.rank of
    Nothing ->
      highest
    Just rank ->
      if rank > highest then
        rank
      else
        highest

highestRank : List Candidate -> Int
highestRank candidates =
  List.foldl (replaceHigherRank) 0 candidates

updateSelect : Candidate -> Int -> Candidate -> Candidate
updateSelect selected highest current =
  case selected.rank of
    Nothing ->
      if selected.id == current.id then
        { current | rank = Just (highest + 1) }
      else
        current

    Just rank ->
      if selected.id == current.id then
        { current | rank = Nothing }
      else
        case current.rank of
          Nothing ->
            current

          Just currentRank ->
            if currentRank > rank then
              { current | rank = Just (currentRank - 1) }
            else
              current

hasVote : Candidate -> Bool
hasVote candidate =
  ((Maybe.withDefault 0 candidate.rank) > 0)

enabled : List Candidate -> Bool
enabled candidates =
  List.any hasVote candidates

-- Render State --

view : Election -> Html Msg
view election =
  if election.candidates == [] then
    div [] [text "Loading election..."]
  else
    div []
      [ h3 [] [ text "Your Ballot" ]
      , ul [ class "list-group" ] (List.map renderCandidate election.candidates)
      , button [ class (buttonClasses election.candidates), onClick Vote ] [ text "Vote" ]
      ]

renderBadge : Maybe Int -> Html Msg
renderBadge maybeRank =
  case maybeRank of
    Nothing ->
      span [ class "badge" ] [ text "" ]
    Just rank ->
      span [ class "badge badge-primary" ] [ text (toString rank) ]

renderCandidate : Candidate -> Html Msg
renderCandidate candidate =
  li [ class "list-group-item", onClick (Select candidate) ]
    [ (renderBadge candidate.rank)
    , text candidate.name
    ]


buttonClasses candidates =
  let
    baseClasses = ["btn", "btn-primary", "btn-block"]
    withDisabled = List.append baseClasses ["disabled"]
  in
    if (enabled candidates) then
      String.join " " baseClasses |> String.trim
    else
      String.join " " withDisabled |> String.trim
