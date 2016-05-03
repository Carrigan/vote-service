defmodule Stv.PageController do
  use Stv.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
