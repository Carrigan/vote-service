port module Index exposing (..)

import Http
import Html exposing (Html, button, div, text, h3, table, tr, th, td, a)
import Html.App as App
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, href)
import String

import Commands exposing (fetchElections, postVote)
import Models exposing (..)

type Msg
  = FetchElectionsSuccess ElectionList
  | FetchElectionsFailure Http.Error

-- Main Application --

main =
    App.program
        { init = initialState
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- Initialization --

initialState : ( List Election, Cmd Msg )
initialState =
  ([], fetchElections FetchElectionsSuccess FetchElectionsFailure)

-- Subscriptions --

subscriptions model =
  Sub.none

-- Update State --

update : Msg -> List Election -> ( List Election, Cmd Msg )
update msg model =
  case msg of
    FetchElectionsSuccess wrappedElections ->
      wrappedElections.data ! []

    FetchElectionsFailure error ->
      model ! []

-- Render State --

headerRow : Html Msg
headerRow =
  tr []
    [ th [] [ text "Election Name" ]
    , th [] [ text "Seats" ]
    , th [] [ text "Created" ]
    ]

buildRow : Election -> Html Msg
buildRow election =
  let
    electionUrl = String.join "/" ["", "vote", (toString election.id)]
  in
    tr []
      [ td [] [ a [ href electionUrl ] [ text election.name ] ]
      , td [] [ text (toString election.seat_count)]
      , td [] [ text election.created_at]
      ]

buildTableRows : List Election -> List (Html Msg)
buildTableRows elections =
  headerRow :: (List.map buildRow elections)

renderListView elections =
  div [ class "col-md-12" ]
    [ h3 [] [ text "Elections Happening Now" ]
    , table [ class "table" ] (buildTableRows elections)
    ]

renderEmptyView =
  div [ class "col-md-12" ] [ text "Loading Elections..." ]

view : List Election -> Html Msg
view elections =
  case elections of
    [] -> renderEmptyView
    el -> renderListView el
