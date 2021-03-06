defmodule VoteService.ElectionView do
  use VoteService.Web, :view
  import Ecto.Query, only: [from: 2]

  def render("index.json", %{elections: elections}) do
    %{data: render_many(elections, VoteService.ElectionView, "election.json")}
  end

  def render("show.json", %{election: election}) do
    %{data: render_one(election, VoteService.ElectionView, "election.json")}
  end

  def render("election.json", %{election: election}) do
    %{id: election.id,
      name: election.name,
      status: election.status,
      created_at: election.inserted_at,
      seat_count: election.seats,
      vote_count: VoteService.Election.vote_count(election),
      candidates: render_many(election.candidates, VoteService.CandidateView, "candidate.json"),
      close_url: election.close_url }
  end
end
