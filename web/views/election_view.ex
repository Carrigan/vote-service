defmodule Stv.ElectionView do
  use Stv.Web, :view

  def render("index.json", %{elections: elections}) do
    %{data: render_many(elections, Stv.ElectionView, "election.json")}
  end

  def render("show.json", %{election: election}) do
    %{data: render_one(election, Stv.ElectionView, "election.json")}
  end

  def render("election.json", %{election: election}) do
    %{id: election.id,
      name: election.name,
      status: election.status,
      candidates: render_many(election.candidates, Stv.CandidateView, "candidate.json")}
  end
end
