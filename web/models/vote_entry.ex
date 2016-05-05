defmodule Stv.VoteEntry do
  use Stv.Web, :model

  schema "vote_entries" do
    field :rank, :integer
    belongs_to :vote, Stv.Vote
    belongs_to :candidate, Stv.Candidate

    timestamps
  end

  @required_fields ~w(rank candidate_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
