defmodule Stv.Repo.Migrations.CreateCandidate do
  use Ecto.Migration

  def change do
    create table(:candidates) do
      add :name, :string
      add :winner, :boolean, default: false
      add :election_id, references(:elections, on_delete: :nothing)

      timestamps
    end
    create index(:candidates, [:election_id])

  end
end
