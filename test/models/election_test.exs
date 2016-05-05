defmodule Stv.ElectionTest do
  use Stv.ModelCase

  alias Stv.Election

  @valid_attrs %{name: "some content"}
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
