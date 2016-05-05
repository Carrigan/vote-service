defmodule Stv.Vote do
  use Stv.Web, :model

  schema "votes" do
    belongs_to :election, Stv.Election
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
  end
end
