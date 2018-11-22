defmodule Discuss.Topics.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Discuss.Topics.Topic

  schema "comments" do
    field :content, :string
    
    belongs_to :user, Discuss.Users.User
    belongs_to :topic, Topic
  end

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:content, :user_id, :topic_id])
    |> validate_required([:content])
  end
end
