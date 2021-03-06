defmodule VoteService.ElectionController do
  use VoteService.Web, :controller

  alias VoteService.Election

  plug :scrub_params, "election" when action in [:create, :update]

  def index(conn, _params) do
    elections = Election.open_elections |> Repo.preload(:candidates)
    render(conn, "index.json", elections: elections)
  end

  def create(conn, %{"election" => election_params}) do
    changeset = Election.changeset(%Election{}, election_params)

    case Repo.insert(changeset) do
      {:ok, election} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", election_path(conn, :show, election))
        |> render("show.json", election: Repo.preload(election, :candidates))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(VoteService.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    election = Repo.get!(Election, id) |> Repo.preload(:candidates)
    render(conn, "show.json", election: election)
  end

  def update(conn, %{"id" => id, "election" => election_params}) do
    election = Repo.get!(Election, id) |> Repo.preload(:candidates)
    changeset = Election.changeset(election, election_params)

    case Repo.update(changeset) do
      {:ok, election} ->
        render(conn, "show.json", election: election)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(VoteService.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    election = Repo.get!(Election, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(election)

    send_resp(conn, :no_content, "")
  end

  def close_poll(conn, params = %{ "url" => url }) do
    election = Repo.get_by!(Election, close_url: url)
    VoteService.ElectionService.run(election.id)
    show(conn, Map.merge(params, %{ "id" => election.id }))
  end
end
