# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     VoteService.Repo.insert!(%VoteService.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias VoteService.Repo
alias VoteService.Election
alias VoteService.Vote

# Create an election with 4 candidates
election = Repo.insert! Election.changeset(
  %Election{},
  %{ name: "Favorite Breakfast", seats: 1, candidates: [
    %{ name: "Pancakes" },
    %{ name: "Omelette" },
    %{ name: "Yogurt" }]})

candidate_ids = Enum.map(election.candidates, fn(candidate) -> candidate.id end)

# Create several votes for this election
Enum.each(
  1..5,
  fn(_) ->
    [id_1, id_2, id_3] = Enum.shuffle(candidate_ids)
    Repo.insert! Vote.create_changeset(
      election,
      %{ vote_entries: [
        %{ candidate_id: id_1, rank: 0 },
        %{ candidate_id: id_2, rank: 1 },
        %{ candidate_id: id_3, rank: 2 }] }) end)
