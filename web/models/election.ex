defmodule VoteService.Election do
  use VoteService.Web, :model
  import Ecto.Query, only: [from: 2]
  alias VoteService.Repo

  schema "elections" do
    field :name, :string
    field :status, :string
    field :seats, :integer
    field :close_url, :string
    has_many :candidates, VoteService.Candidate
    has_many :votes, VoteService.Vote
    timestamps
  end

  @required_fields ~w(name seats)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> put_change(:close_url, random_string(32))
    |> put_change(:status, "open")
    |> cast_assoc(:candidates, required: true)
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  def open_elections() do
    query = from e in __MODULE__, where: e.status == "open"
    Repo.all(query)
  end

  def close(model) do
    change(model) |> put_change(:status, "closed")
  end

  def vote_count(model) do
    query = from v in VoteService.Vote, select: count(v.id), where: v.election_id == ^model.id
    [count | _] = Repo.all(query)
    count
  end
end
