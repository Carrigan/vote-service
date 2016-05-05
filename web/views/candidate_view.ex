defmodule VoteService.CandidateView do
  use VoteService.Web, :view

  def render("index.json", %{candidates: candidates}) do
    %{data: render_many(candidates, VoteService.CandidateView, "candidate.json")}
  end

  def render("show.json", %{candidate: candidate}) do
    %{data: render_one(candidate, VoteService.CandidateView, "candidate.json")}
  end

  def render("candidate.json", %{candidate: candidate}) do
    %{id: candidate.id,
      name: candidate.name,
      election_id: candidate.election_id,
      winner: candidate.winner}
  end
end
