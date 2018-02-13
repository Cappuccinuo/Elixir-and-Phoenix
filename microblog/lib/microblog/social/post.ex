defmodule Microblog.Social.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Social.Post


  schema "posts" do
    field :body, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
