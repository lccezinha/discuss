defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics
  alias Discuss.Topics.Topic

  def index(conn, _params) do
    topics = Topics.list_topics()

    render conn, "index.html", topics: topics
  end

  def new(conn, params) do
    changeset = Topic.changeset(%Topic{}, params)

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    case Topics.create_topic(topic) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Topic created!")
        |> redirect(to: topic_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)

    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => id, "topic" => params}) do
    topic = Topics.get_topic!(id)

    case Topics.update_topic(topic, params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Topic edited!")
        |> redirect(to: topic_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: topic)
    end
  end
end
