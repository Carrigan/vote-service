defmodule VoteService.Repo.Migrations.AddElectionObfuscation do
  use Ecto.Migration

  def change do
    alter table(:elections) do
      add :close_url, :string
    end
  end
end
