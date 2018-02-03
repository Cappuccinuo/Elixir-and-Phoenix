defmodule DemoWeb.PageController do
  use DemoWeb, :controller

  def index(conn, params) do
    name = get_session(conn, :name) || "none"
    render conn, "index.html", name: params["name"]
  end

  # for form submission
  def form(conn, params) do
    # Try to remember the value
    conn = put_session(conn, :name, params["name"])
    render conn, "form.html", name: params["name"]
  end
end
