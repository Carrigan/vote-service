defmodule Stv.Candidate do
  use Stv.Web, :model

  schema "candidates" do
    field :name, :string
    field :winner, :boolean, default: false
    belongs_to :election, Stv.Election

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> put_change(:winner, false)
  end
end
