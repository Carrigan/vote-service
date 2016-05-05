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
    pipe_through :browser
    get "/", PageController, :index
  end

  scope "/api", Stv do
    pipe_through :api
    resources "/elections", ElectionController, except: [:new, :edit] do
      resources "/votes", VoteController, except: [:new, :edit, :update, :delete]
    end
  end
end
