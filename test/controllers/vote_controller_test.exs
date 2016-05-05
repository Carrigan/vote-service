defmodule Stv.VoteControllerTest do
  use Stv.ConnCase

  alias Stv.Vote
  alias Stv.Election
  @invalid_attrs %{}

  setup %{conn: conn} do
    election = Repo.insert!(%Election{}, name: "Best Beer")
    candidate_a = Ecto.build_assoc(election, :candidates, name: "Candidate A") |> Repo.insert!()
    candidate_b = Ecto.build_assoc(election, :candidates, name: "Candidate B") |> Repo.insert!()
    {:ok,
      conn: put_req_header(conn, "accept", "application/json"),
      election: election,
      candidate_a: candidate_a.id,
      candidate_b: candidate_b.id }
  end

  def valid_attrs(id_1, id_2) do
    %{"vote_entries" => [
      %{"candidate_id" => id_1, "rank" => 0},
      %{"candidate_id" => id_2, "rank" => 1}]}
  end

  test "lists all entries on index", %{conn: conn, election: election} do
    conn = get conn, election_vote_path(conn, :index, election)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, election: election, candidate_a: a, candidate_b: b} do
    vote = Repo.insert! Vote.create_changeset(election, valid_attrs(a, b))
    conn = get conn, election_vote_path(conn, :show, election, vote)
    assert json_response(conn, 200)["data"] == %{"id" => vote.id,
      "election_id" => vote.election_id,
      "candidates" => [a, b]}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn, election: election} do
    assert_error_sent 404, fn ->
      get conn, election_vote_path(conn, :show, election, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, election: election, candidate_a: a, candidate_b: b} do
    conn = post conn, election_vote_path(conn, :create, election), vote: valid_attrs(a, b)
    assert json_response(conn, 201)["data"]["id"]
  end
end
