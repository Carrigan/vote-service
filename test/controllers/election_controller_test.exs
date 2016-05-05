defmodule Stv.ElectionControllerTest do
  use Stv.ConnCase

  alias Stv.Election
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, election_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    election = Repo.insert! %Election{}
    conn = get conn, election_path(conn, :show, election)
    assert json_response(conn, 200)["data"] == %{"id" => election.id,
      "name" => election.name,
      "status" => election.status}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, election_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, election_path(conn, :create), election: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Election, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, election_path(conn, :create), election: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    election = Repo.insert! %Election{}
    conn = put conn, election_path(conn, :update, election), election: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Election, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    election = Repo.insert! %Election{}
    conn = put conn, election_path(conn, :update, election), election: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    election = Repo.insert! %Election{}
    conn = delete conn, election_path(conn, :delete, election)
    assert response(conn, 204)
    refute Repo.get(Election, election.id)
  end
end