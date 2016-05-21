defmodule VoteService.ElectionServiceTest do
  use VoteService.ModelCase
  alias VoteService.Vote
  alias VoteService.Election

  setup do
    { election, winner } = VoteService.SampleElection.build
    { :ok, election: election, expected_winner: winner }
  end

  test "it closes the election", %{election: election} do
    VoteService.ElectionService.run(election.id)
    assert Repo.get!(Election, election.id).status == "closed"
  end

  test "it elects the expected winners", %{election: election, expected_winner: winner} do
    VoteService.ElectionService.run(election.id)
    assert Repo.get!(VoteService.Candidate, winner.id).winner == true
  end
end


