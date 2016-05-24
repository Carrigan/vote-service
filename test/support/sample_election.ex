defmodule VoteService.SampleElection do
  alias VoteService.Election
  alias VoteService.Vote
  alias VoteService.Repo

  def build(count) do
    election = build_election
    {[winner], rest} = split_candidates election.candidates
    build_votes!(election, winner, rest, count)
    { election, winner }
  end

  def split_candidates(candidates) do
    Enum.split(candidates, 1)
  end

  def build_votes!(election, winner, rest, count) do
    Enum.each(0..(count - 1), fn(x) -> build_vote(election, winner, rest) end)
  end

  def build_vote(election, winner, rest) do
    others = Enum.shuffle(rest) |> Enum.take(3)
    Repo.insert! %Vote { election_id: election.id, vote_entries: vote_entries([winner | others]) }
  end

  def vote_entries(candidates) do
    Enum.with_index(candidates)
    |> Enum.map(fn({candidate, i}) -> %{ candidate_id: candidate.id, rank: i } end)
  end

  def build_election() do
    Repo.insert! %Election {
      name: "County Commissioner",
      seats: 1,
      candidates: [
        %{ name: "Wendy Jacobs" },
        %{ name: "Ellen Reckhow" },
        %{ name: "Heidi Carter" },
        %{ name: "Brenda Howerton" },
        %{ name: "James Hill" },
        %{ name: "Michael D. Page" },
        %{ name: "Elaine C. Hyman" },
        %{ name: "Fred Foster, Jr." },
        %{ name: "Glyndola Massenburg-Beasley" },
        %{ name: "Tara L. Fikes" }]}
  end
end
