defmodule Stv.Repo.Migrations.CreateVoteEntry do
  use Ecto.Migration

  def change do
    create table(:vote_entries) do
      add :rank, :integer
      add :vote_id, references(:votes, on_delete: :nothing)
      add :candidate_id, references(:candidates, on_delete: :nothing)

      timestamps
    end
    create index(:vote_entries, [:vote_id])
    create index(:vote_entries, [:candidate_id])

  end
end
