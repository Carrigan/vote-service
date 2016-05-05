defmodule Stv.Repo.Migrations.CreateVote do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :election_id, references(:elections, on_delete: :nothing)

      timestamps
    end
    create index(:votes, [:election_id])

  end
end
