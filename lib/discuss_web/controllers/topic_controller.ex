defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics
  alias Discuss.Topics.Topic

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    topics = Topics.list_topics()

    render conn, "index.html", topics: topics
  end

  def new(conn, params) do
    changeset = Topic.changeset(%Topic{}, params)

    render conn, "new.html", changeset: changeset
  end

  def show(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)

    render conn, "show.html", topic: topic
  end

  def create(conn, %{"topic" => topic_params}) do
    topic_params =
      topic_params
      |> Map.merge(%{"user_id" => conn.assigns.user.id})

    case Topics.create_topic(topic_params) do
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

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Topics.get_topic!(id)

    topic_params =
      topic_params
      |> Map.merge(%{"user_id" => conn.assigns.user.id})

    case Topics.update_topic(topic, topic_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Topic edited!")
        |> redirect(to: topic_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)
    {:ok, _topic} = Topics.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted!")
    |> redirect(to: topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    if Topics.get_topic!(topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You're not the owner of this topic!")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end
end
