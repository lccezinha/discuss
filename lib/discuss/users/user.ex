defmodule Discuss.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Topics.{Topic, Comment}

  schema "users" do
    field :email, :string
    field :name, :string
    field :token, :string

    has_many :topics, Topic
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :token])
    |> validate_required([:email, :name, :token])
  end
end
