defmodule VoteService.VoteTest do
  use VoteService.ModelCase

  alias VoteService.Vote
  alias VoteService.Election

  setup do
    election = Repo.insert! %Election{name: "Beers", seats: 1}
    pbr = build_assoc(election, :candidates, name: "PBR") |> Repo.insert!
    { :ok, election: election, candidate: pbr }
  end

  defp vote(candidate_id) do
    %{vote_entries: [%{candidate_id: candidate_id, rank: 0}]}
  end

  test "changeset with valid attributes", %{election: election, candidate: candidate} do
    changeset = Vote.create_changeset(election, vote(candidate.id))
    assert changeset.valid?
  end

  test "when the election is closed", %{election: election, candidate: candidate} do
    election = election |> Election.close() |> Repo.update!()
    changeset = Vote.create_changeset(election, vote(candidate.id))
    assert changeset.valid? == false
  end

  test "when the vote contains candidates not in the election", %{election: election} do
    changeset = Vote.create_changeset(election, vote(9000))
    assert changeset.valid? == false
  end
end
