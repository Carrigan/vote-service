defmodule VoteService.Repo.Migrations.AddSeatsToElection do
  use Ecto.Migration

  def change do
    alter table(:elections) do
      add :seats, :integer
    end
  end
end
