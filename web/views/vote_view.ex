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
      election_id: vote.election_id,
      candidates: ordered_candidates(vote.vote_entries)}
  end

  def ordered_candidates(vote_entries) do
    vote_entries
    |> Enum.sort_by(fn(%{rank: rank}) -> rank end)
    |> Enum.map(fn(%{candidate_id: id}) -> id end)
  end
end
