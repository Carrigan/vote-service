defmodule VoteService.ElectionService do
  alias VoteService.Candidate
  alias VoteService.Election
  alias VoteService.Repo

  def run(election_id) do
    Repo.get!(Election, election_id)
    |> Repo.preload(:votes)
    |> Repo.preload(votes: :vote_entries)
    |> run_election()
  end

  defp run_election(election) do
    stv_votes(election) |> Stv.compute(election.seats) |> elect_winners()
    Election.close(election) |> Repo.update!()
  end

  defp stv_votes(election) do
    Enum.map(election.votes, fn(vote) -> format_for_stv(vote) end)
  end

  defp elect_winners(winner_ids) do
    Enum.map(winners(winner_ids), fn(winner) -> Candidate.elect(winner) |> Repo.update!() end)
  end

  defp winners(winner_ids) do
    Enum.map(winner_ids, fn(id) -> Repo.get(Candidate, id) end)
  end

  defp format_for_stv(vote) do
    vote.vote_entries
    |> Enum.sort(fn(e1, e2) -> e1.rank < e2.rank end)
    |> Enum.map(fn(entry) -> entry.candidate_id end)
  end
end
