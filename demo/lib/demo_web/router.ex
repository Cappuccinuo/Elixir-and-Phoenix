# When there is a http request, first check router.ex
# Plug's basic idea:
#   A web server is a pure function:
#   - Maps HTTP Request => HTTP Responses

#   Lots of steps: each step is a function: Conn => Conn
#   Conn structure:
#      - Request
#      - Partially built response

#   Phoenix steps to handle a request
#   Every step is a (Conn to Conn) function
#     - Router
#     - Pipeline plugs
#     - Controller
#     - View
#     - Template

defmodule DemoWeb.Router do
  use DemoWeb, :router

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

  scope "/", DemoWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/form", PageController, :form
  end

  # Other scopes may use custom stacks.
  # scope "/api", DemoWeb do
  #   pipe_through :api
  # end
end
