defmodule Stv.VoteView do
  use Stv.Web, :view

  def render("index.json", %{votes: votes}) do
    %{data: render_many(votes, Stv.VoteView, "vote.json")}
  end

  def render("show.json", %{vote: vote}) do
    %{data: render_one(vote, Stv.VoteView, "vote.json")}
  end

  def render("vote.json", %{vote: vote}) do
    %{id: vote.id,
      election_id: vote.election_id}
  end
end
