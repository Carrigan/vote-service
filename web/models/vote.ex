defmodule VoteService.Vote do
  use VoteService.Web, :model
  alias VoteService.Repo

  schema "votes" do
    belongs_to :election, VoteService.Election
    has_many :vote_entries, VoteService.VoteEntry
    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """

  def create_changeset(election, params \\ :empty) do
    build_assoc(election, :votes)
    |> cast(params, @required_fields, @optional_fields)
    |> cast_assoc(:vote_entries, required: true)
    |> validate_election_open(election)
    |> validate_entries(election)
  end

  defp validate_election_open(changeset, %{status: "closed"}) do
    add_error(changeset, :election, "closed")
  end

  defp validate_election_open(changeset, _), do: changeset

  defp validate_entries(changeset, election) do
    get_change(changeset, :vote_entries)
    |> Enum.reduce(changeset, fn(entry, changes) -> validate_entry(changes, election, entry) end)
  end

  defp validate_entry(changeset, election, entry) do
    id = get_change(entry, :candidate_id)
    valid_candidates = assoc(election, :candidates)
    candidate = Repo.get(valid_candidates, id)
    validate_candidate(changeset, candidate, id)
  end

  defp validate_candidate(changeset, nil, id) do
    add_error(changeset, :vote_entries, "Candidate #{id} is not in this election")
  end

  defp validate_candidate(changeset, _, _), do: changeset
end
