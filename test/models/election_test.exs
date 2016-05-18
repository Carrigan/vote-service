defmodule VoteService.ElectionTest do
  use VoteService.ModelCase

  alias VoteService.Election

  @valid_attrs %{ name: "some content", seats: 1 }
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

  test "changeset with invalid attributes" do
    changeset = Election.changeset(%Election{}, @invalid_attrs)
    refute changeset.valid?
  end
end
