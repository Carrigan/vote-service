defmodule VoteService.PageController do
  use VoteService.Web, :controller

  alias VoteService.Election

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new_election(conn, _params) do
    render conn, "new.html"
  end

  def vote(conn, params = %{"id" => id}) do
    election = Repo.get(Election, id)
    render_vote conn, params, election
  end

  def render_vote(conn, params, %{status: "closed"}), do: results(conn, params)
  def render_vote(conn, _, election), do: render conn, "vote.html", election: election

  def results(conn, %{"id" => id}) do
    render conn, "results.html", election_id: id
  end
end
