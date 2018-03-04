defmodule MicroblogWeb.Router do
  use MicroblogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session   # parses the Cookie header
    plug :get_current_user
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  def get_current_user(conn, _params) do
    user_id = get_session(conn, :user_id)
    if user_id do
      user = Microblog.Accounts.get_user!(user_id)
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MicroblogWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/posts", PostController
    post "/session", SessionController, :create # method
    delete "/session", SessionController, :delete # method
    get "/feed", PageController, :feed
  end

  # Other scopes may use custom stacks.
  # scope "/api", MicroblogWeb do
  #   pipe_through :api
  # end
end
