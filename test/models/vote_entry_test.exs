defmodule Stv.VoteEntryTest do
  use Stv.ModelCase

  alias Stv.VoteEntry
  alias Stv.Election

  @valid_attrs %{rank: 42}
  @invalid_attrs %{}

  setup do
    election = Repo.insert!(%Election{}, name: "Best Beer")
    candidate = Ecto.build_assoc(election, :candidates, name: "Bud Light") |> Repo.insert!()
    {:ok, candidate: candidate}
  end

  test "changeset with valid attributes", %{candidate: candidate} do
    changeset = VoteEntry.changeset(%VoteEntry{}, %{rank: 42, candidate_id: candidate.id})
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = VoteEntry.changeset(%VoteEntry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
