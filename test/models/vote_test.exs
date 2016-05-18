defmodule VoteService.VoteTest do
  use VoteService.ModelCase

  alias VoteService.Vote
  alias VoteService.Election
  @valid_attrs %{vote_entries: [%{candidate_id: 1, rank: 0}]}
  @invalid_attrs %{}

  setup do
    {:ok, election: Repo.insert!(%Election{name: "Best Beer"})}
  end

  test "changeset with valid attributes", %{election: election} do
    changeset = Vote.create_changeset(election, @valid_attrs)
    assert changeset.valid?
  end
end
