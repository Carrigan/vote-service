defmodule Stv.VoteControllerTest do
  use Stv.ConnCase

  alias Stv.Vote
  alias Stv.Election
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    election = Repo.insert!(%Election{}, name: "Best Beer")
    {:ok, conn: put_req_header(conn, "accept", "application/json"), election: election}
  end

  test "lists all entries on index", %{conn: conn, election: election} do
    conn = get conn, election_vote_path(conn, :index, election)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, election: election} do
    vote = Repo.insert! %Vote{}
    conn = get conn, election_vote_path(conn, :show, election, vote)
    assert json_response(conn, 200)["data"] == %{"id" => vote.id,
      "election_id" => vote.election_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn, election: election} do
    assert_error_sent 404, fn ->
      get conn, election_vote_path(conn, :show, election, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, election: election} do
    conn = post conn, election_vote_path(conn, :create, election), vote: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Vote, @valid_attrs)
  end
end
