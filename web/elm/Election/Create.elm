module Election.Create exposing (..)

import Html.Attributes exposing (..)
import Html exposing (Html, Attribute, text, div, input)
import Html.Events exposing (on, onInput, onClick, keyCode)
import Election.Messages exposing (..)
import Json.Decode as Json


view election =
  div []
    [ input [ placeholder "Election Name", onInput ElectionName, myStyle ] []
    , input [ placeholder "Seat Count", onInput SeatCount, myStyle ] []
    , div [] (List.map renderCandidate election.candidates)
    , div [onClick AddCandidate, buttonStyle] [text "New Candidate"]
    , div [onClick CreateElection, buttonStyle] [text "Create Election"]
    ]

onEnter : msg -> msg -> Attribute msg
onEnter fail success =
  let
    tagger code =
      if code == 13 then success
      else fail
  in
    on "keyup" (Json.map tagger keyCode)

renderCandidate candidate =
  div []
    [ input [ placeholder "New Candidate", myStyle, onInput (EditCandidate candidate.id), onEnter NoOp AddCandidate ] [] ]

buttonStyle =
  style
    [ ("margin", "10px")
    , ("padding", "10px")
    , ("font-size", "2em")
    , ("background-color", "#DDD")
    , ("text-align", "center")
    ]

myStyle =
  style
    [ ("width", "100%")
    , ("height", "40px")
    , ("padding", "10px 0")
    , ("font-size", "2em")
    , ("text-align", "center")
    ]
