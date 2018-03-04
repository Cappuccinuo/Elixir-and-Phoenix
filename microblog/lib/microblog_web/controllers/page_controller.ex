defmodule MicroblogWeb.PageController do
  use MicroblogWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def feed(conn, _params) do
    posts = Microblog.Social.list_posts()
    new_post = %Microblog.Social.Post{ user_id: conn.assigns[:current_user].id }
    changeset = Microblog.Social.change_post(new_post)
    render conn, "feed.html", posts: posts, changeset: changeset
  end
end
