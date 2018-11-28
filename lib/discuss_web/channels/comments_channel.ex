defmodule Discuss.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Topics

  def join("comments:" <> topic_id, _auth_msg, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topics.get_topic!(topic_id)
    IO.inspect(topic)
    {:ok, %{}, socket}
  end

  def handle_in(name, %{"content" => content}, socket) do
    IO.inspect(content)
    {:reply, :ok, socket}
  end
end