defmodule Microblog.Social.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Social.Post


  schema "posts" do
    field :body, :string
    # field :user_id, :id
    belongs_to :user, Microblog.Accounts.User
    timestamps()
  end

  @doc false
  # do validation
  # cast data type match schema
  # validate_required check null
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:body, :user_id])
    |> validate_required([:body, :user_id])
  end
end
