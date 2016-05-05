defmodule VoteService.Repo.Migrations.CreateElection do
  use Ecto.Migration

  def change do
    create table(:elections) do
      add :name, :string
      add :status, :string

      timestamps
    end

  end
end
