defmodule VoteService.Router do
  use VoteService.Web, :router

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

  scope "/", VoteService do
    pipe_through :browser
    get "/", PageController, :index
    get "/new", PageController, :new_election
    get "/vote/:id", PageController, :vote
    get "/results/:id", PageController, :results
  end

  scope "/api", VoteService do
    pipe_through :api
    get "/close_poll/:url", ElectionController, :close_poll
    resources "/elections", ElectionController, except: [:new, :edit] do
      resources "/votes", VoteController, except: [:new, :edit, :update, :delete]
    end
  end
end
