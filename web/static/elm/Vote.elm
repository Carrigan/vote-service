port module Vote exposing (..)

import Http
import Html exposing (Html, button, div, text, h3, ul, li, span)
import Html.App as App
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import String

import Commands exposing (fetchElection, postVote)
import Models exposing (..)

hasVote candidate =
  ((Maybe.withDefault 0 candidate.rank) > 0)

enabled candidates =
  List.any hasVote candidates

type Msg
  = Select Candidate
  | FetchSucceed ElectionWrapped
  | FetchFail Http.Error
  | Vote
  | VoteSucceed Int
  | VoteFail Http.Error

initialState : String -> ( Election, Cmd Msg )
initialState electionString =
  case String.toInt electionString of
    Ok electionId ->
      ({ id = 0, candidates = [] }, fetchElection electionId FetchSucceed FetchFail)
    Err _ ->
      { id = 0, candidates = [] } ! []

subscriptions model =
    Sub.none

main =
    App.programWithFlags
        { init = initialState
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

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

port voteComplete : Int -> Cmd msg

update : Msg -> Election -> ( Election, Cmd Msg )
update msg model =
  case msg of
    Select candidate ->
      let
        candidates = model.candidates
      in
        { model | candidates = (List.map (updateSelect candidate (highestRank candidates)) candidates) } ! []

    FetchSucceed wrappedElection ->
      wrappedElection.data ! []

    FetchFail error ->
      model ! []

    Vote ->
      if (enabled model.candidates) then
        (model, postVote model.id model.candidates VoteFail VoteSucceed)
      else
        model ! []

    VoteSucceed voteId ->
      (model, voteComplete 0)

    VoteFail error ->
      model ! []

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

view model =
  if model.candidates == [] then
    div [] [text "Loading election..."]
  else
    div []
      [ h3 [] [ text "Your Ballot" ]
      , ul [ class "list-group" ] (List.map renderCandidate model.candidates)
      , button [ class (buttonClasses model.candidates), onClick Vote ] [ text "Vote" ]
      ]