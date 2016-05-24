defmodule VoteService.PageController do
  use VoteService.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new_election(conn, _params) do
    render conn, "new.html"
  end

  def vote(conn, %{"id" => id}) do
    render conn, "vote.html", vote_id: id
  end

  def results(conn, %{"id" => id}) do
    render conn, "results.html", election_id: id
  end
end
