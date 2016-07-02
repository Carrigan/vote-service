defmodule VoteService.VoteTest do
  use VoteService.ModelCase

  alias VoteService.Vote
  alias VoteService.Election
  @valid_attrs %{vote_entries: [%{candidate_id: 1, rank: 0}]}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    election = Repo.insert!(%Election{name: "Best Beer"})
    changeset = Vote.create_changeset(election, @valid_attrs)
    assert changeset.valid?
  end

  test "when the election is closed" do
    election = Repo.insert!(%Election{name: "Best Beer"})
      |> Election.close()
      |> Repo.update!()
    changeset = Vote.create_changeset(election, @valid_attrs)
    assert changeset.valid? == false
  end
end
