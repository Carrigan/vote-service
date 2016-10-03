defmodule VoteService.VoteController do
  use VoteService.Web, :controller

  alias VoteService.Vote
  alias VoteService.Election

  #plug :scrub_params, "vote" when action in [:create, :update]

  def index(conn, %{"election_id" => election_id}) do
    votes = Repo.all(from v in Vote, where: v.election_id == ^election_id, preload: [:vote_entries])
    render(conn, "index.json", votes: votes)
  end

  def create(conn, params = %{"election_id" => election_id, "vote" => vote_params}) do
    IO.inspect params
    election = Repo.get!(Election, election_id)
    changeset = Vote.create_changeset(election, vote_params)

    case Repo.insert(changeset) do
      {:ok, vote} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", election_vote_path(conn, :show, election, vote))
        |> render("show.json", vote: Repo.preload(vote, :vote_entries))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(VoteService.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    vote = Repo.get!(Vote, id) |> Repo.preload(:vote_entries)
    render(conn, "show.json", vote: vote)
  end
end
