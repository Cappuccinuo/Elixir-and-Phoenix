defmodule HangmanWeb.PageController do
  use HangmanWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  # Trying to match game_name, so we need params
  def game(conn, params) do
    render conn, "game.html", game: params["game"]
  end
end
