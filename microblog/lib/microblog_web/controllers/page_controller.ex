defmodule MicroblogWeb.PageController do
  use MicroblogWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def feed(conn, _params) do
    posts = Microblog.Social.list_posts()
    changeset = Microblog.Social.change_post(%Microblog.Social.Post{})
    render conn, "feed.html", posts: posts, changeset: changeset
  end
end
