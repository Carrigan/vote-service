import Html exposing (Html, Attribute, text, div, input)
import Html.App exposing (program)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import Json.Encode as Encode
import Http
import String
import Task


main =
  program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

subscriptions model =
  Sub.none

init =
  (newElection, Cmd.none)

type alias Candidate =
  { name : String
  , id : Int
  }

type alias Election =
  { candidates : List Candidate
  , name : String
  , seats : Int
  , currentId : Int
  }

newElection : Election
newElection =
  { candidates = [newCandidate 0]
  , name = ""
  , seats = 1
  , currentId = 0
  }

newCandidate : Int -> Candidate
newCandidate id =
  { name = ""
  , id = id
  }

-- UPDATE

type Msg =
  NoOp |
  ElectionName String |
  SeatCount String |
  EditCandidate Int String |
  AddCandidate |
  CreateElection |
  CreateElectionSuccess Http.Response |
  CreateElectionFailure Http.RawError

update msg election =
  case msg of
    NoOp ->
      (election, Cmd.none)

    ElectionName string ->
      ({ election | name = string }, Cmd.none)

    SeatCount string ->
      case String.toInt string of
        Err str ->   (election, Cmd.none)
        Ok n      -> ({ election | seats = n }, Cmd.none)

    EditCandidate candidate_id string ->
      let
        updateCandidate c =
          if c.id == candidate_id then { c | name = string } else c
      in
        ({ election | candidates = List.map updateCandidate election.candidates }
        , Cmd.none)

    AddCandidate ->
      let
        newId = election.currentId + 1

      in
        ({ election | candidates = List.append election.candidates [(newCandidate newId)]
                    , currentId = newId }
        , Cmd.none)

    CreateElection ->
      (election, createElection election)

    CreateElectionSuccess resp ->
      (election, Cmd.none)

    CreateElectionFailure err ->
      (election, Cmd.none)

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

-- VIEW

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
