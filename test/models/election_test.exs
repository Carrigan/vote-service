defmodule VoteService.ElectionTest do
  use VoteService.ModelCase

  alias VoteService.Election

  @valid_attrs %{ name: "some content", seats: 1, candidates: [%{name: "some candidate"}] }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Election.changeset(%Election{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset adds status to new Election" do
    changeset = Election.changeset(%Election{}, @valid_attrs)
    { :ok, status } = Map.fetch(changeset.changes, :status)
    assert status == "open"
  end

  test "changeset has a strong close_url link" do
    changeset = Election.changeset(%Election{}, @valid_attrs)
    { :ok, url } = Map.fetch(changeset.changes, :close_url)
    assert url != nil
  end

  test "changeset with invalid attributes" do
    changeset = Election.changeset(%Election{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "vote_count returns the proper number of votes on an election" do
    { election, _ } = VoteService.SampleElection.build(5)
    assert Election.vote_count(election) == 5
  end
end
