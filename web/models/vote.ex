defmodule VoteService.Vote do
  use VoteService.Web, :model

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
  end

  def validate_election_open(changeset, %{status: "closed"}) do
    add_error(changeset, :election, "closed")
  end

  def validate_election_open(changeset, _), do: changeset
end
