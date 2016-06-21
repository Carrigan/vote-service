module Messages exposing (..)

import Election.Messages

type Msg
    = ElectionMsg Election.Messages.Msg
