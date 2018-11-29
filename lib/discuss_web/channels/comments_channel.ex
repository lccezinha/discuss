defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Topics

  def join("comments:" <> topic_id, _auth_msg, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topics.get_topic_with_comments_preload(topic_id)
    
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(_event, %{"content" => content}, socket) do
    topic = socket.assigns.topic

    case Topics.create_comment(topic, content) do
      {:ok, _comment} ->
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, %{errors: reason}}, socket}
    end
  end
end