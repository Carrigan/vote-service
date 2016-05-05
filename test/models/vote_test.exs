defmodule Stv.VoteTest do
  use Stv.ModelCase

  alias Stv.Vote
  alias Stv.Election
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    {:ok, election: Repo.insert!(%Election{}, name: "Best Beer")}
  end

  test "changeset with valid attributes", %{election: election} do
    changeset = Vote.create_changeset(election, @valid_attrs)
    assert changeset.valid?
  end
end
