defmodule Discuss.Topics.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Discuss.Topics.Topic

  schema "topics" do
    field :title, :string
    
    belongs_to :user, Discuss.Users.User
  end

  @doc false
  def changeset(%Topic{} = topic, attrs \\ %{}) do
    topic
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title])
  end
end
