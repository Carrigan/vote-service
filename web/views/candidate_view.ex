defmodule Stv.CandidateView do
  use Stv.Web, :view

  def render("index.json", %{candidates: candidates}) do
    %{data: render_many(candidates, Stv.CandidateView, "candidate.json")}
  end

  def render("show.json", %{candidate: candidate}) do
    %{data: render_one(candidate, Stv.CandidateView, "candidate.json")}
  end

  def render("candidate.json", %{candidate: candidate}) do
    %{id: candidate.id,
      name: candidate.name,
      election_id: candidate.election_id,
      winner: candidate.winner}
  end
end
