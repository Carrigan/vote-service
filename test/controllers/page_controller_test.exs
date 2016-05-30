defmodule VoteService.PageControllerTest do
  use VoteService.ConnCase

  setup %{conn: conn} do
    { election, _ } = VoteService.SampleElection.build(10)
    { :ok, conn: conn, election: election }
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Open Ballot"
  end

  test "GET /new", %{conn: conn} do
    conn = get conn, "/new"
    assert html_response(conn, 200) =~ "Open Ballot"
  end

  test "GET /vote", %{conn: conn, election: election} do
    conn = get conn, "/vote/#{election.id}"
    assert html_response(conn, 200) =~ "Open Ballot"
  end

  test "GET /results", %{conn: conn, election: election} do
    conn = get conn, "/results/#{election.id}"
    assert html_response(conn, 200) =~ "Open Ballot"
  end
end
