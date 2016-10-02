module Vote exposing (main)

import Http
import Html exposing (Html, button, div, text, h3, ul, li, span)
import Html.App as App
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)

import Commands exposing (fetchElection)
import Models exposing (..)

type Msg
  = Select Candidate
  | FetchSucceed ElectionWrapped
  | FetchFail Http.Error

initialState : ( List Candidate, Cmd Msg )
initialState =
  ([], fetchElection 48 FetchSucceed FetchFail)

subscriptions model =
    Sub.none

main =
    App.program
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

update : Msg -> List Candidate -> ( List Candidate, Cmd Msg )
update msg model =
  case msg of
    Select candidate ->
      (List.map (updateSelect candidate (highestRank model)) model) ! []

    FetchSucceed wrappedElection ->
      wrappedElection.data.candidates ! []

    FetchFail error ->
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

view model =
  div []
    [ h3 [] [ text "Your Ballot" ]
    , ul [ class "list-group" ] (List.map renderCandidate model)
    , button [ class "btn btn-primary btn-block" ] [ text "Vote" ]
    ]
