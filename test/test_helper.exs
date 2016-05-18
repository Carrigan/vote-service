ExUnit.start

Mix.Task.run "ecto.create", ~w(-r VoteService.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r VoteService.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(VoteService.Repo, :manual)

