defmodule Stv.Router do
  use Stv.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Stv do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Stv do
    pipe_through :api
    resources "/elections", ElectionController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Stv do
  #   pipe_through :api
  # end
end
