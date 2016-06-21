module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model)
import Election.Update

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ElectionMsg subMsg ->
            let
                ( updatedElection, cmd ) =
                    Election.Update.update subMsg model.election
            in
                ( { model | election = updatedElection }, Cmd.map ElectionMsg cmd )
