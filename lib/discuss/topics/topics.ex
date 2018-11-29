defmodule Discuss.Topics do
  @moduledoc """
    Topics context
  """

  import Ecto.Query, warn: false

  alias Discuss.Repo
  alias Discuss.Topics.{Topic, Comment}

  def get_topic!(id), do: Repo.get!(Topic, id)

  def list_topics, do: Repo.all(Topic)

  def create_topic(params \\ %{}) do
    %Topic{}
    |> Topic.changeset(params)
    |> Repo.insert()
  end

  def update_topic(topic, params) do
    topic
    |> Topic.changeset(params)
    |> Repo.update()
  end

  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  def create_comment(topic, content) do
    topic
    |> Ecto.build_assoc(:comments, user_id: topic.user_id)
    |> Comment.changeset(%{content: content})
    |> Repo.insert()
  end
end
