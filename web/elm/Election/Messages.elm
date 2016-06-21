module Election.Messages exposing (..)

import Http

type Msg
  = NoOp
  | ElectionName String
  | SeatCount String
  | EditCandidate Int String
  | AddCandidate
  | CreateElection
  | CreateElectionSuccess Http.Response
  | CreateElectionFailure Http.RawError
