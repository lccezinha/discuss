defmodule DiscussWeb.CommentsChannelTest do
  use DiscussWeb.ChannelCase

  alias Discuss.Factory
  alias Discuss.Repo

  def topic_factory do
    Factory.insert(:topic)
  end

  def comment_factory(attrs) do
    Factory.build(:comment, attrs)
  end

  setup do
    {:ok, socket} = connect(DiscussWeb.UserSocket, %{})

    {:ok, socket: socket}
  end

  describe "join" do
    test "join to a topic channel and fetch related comments", %{socket: socket} do
      topic = topic_factory()
      {:ok, comment} = comment_factory(%{topic_id: topic.id}) |> Repo.insert()

      assert {:ok, %{comments: comments}, socket} = subscribe_and_join(socket, "comments:#{topic.id}", %{})
      assert socket.assigns.topic.id == topic.id
      assert length(comments) == 1
      assert Enum.at(comments, 0).content == comment.content
    end
  end

  describe "handle_in" do
    test "receive a valid content and create new comment", %{socket: socket} do
      topic = topic_factory()
      {:ok, _payload, socket} = subscribe_and_join(socket, "comments:#{topic.id}", %{})

      ref = push(socket, "comments:add", %{"content" => "my content"})
      assert_reply ref, :ok, %{}
    end

    test "receive an invalid content and create new comment", %{socket: socket} do
      topic = topic_factory()
      {:ok, _payload, socket} = subscribe_and_join(socket, "comments:#{topic.id}", %{})

      ref = push(socket, "comments:add", %{"content" => ""})
      assert_reply ref, :error, %{errors: reason}
    end

    test "broadcast new comment through the topic" do
    end
  end
end
