module Models exposing (..)

import Election.Models exposing (Election, newElection)

type alias Model =
    { election : Election
    }

initialModel : Model
initialModel =
    { election = newElection
    }
