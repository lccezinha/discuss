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
    test "join current topic to correct comments channel", %{socket: socket} do
      topic = topic_factory()

      assert {:ok, _reply, socket} = subscribe_and_join(socket, "comments:#{topic.id}", %{})
      assert socket.assigns.topic.id == topic.id
    end

    test "join to channel and fetch related comments", %{socket: socket} do
      topic = topic_factory()
      {:ok, comment} = comment_factory(%{topic_id: topic.id}) |> Repo.insert()

      assert {:ok, %{comments: comments}, _socket} = subscribe_and_join(socket, "comments:#{topic.id}", %{})
      assert length(comments) == 1
      assert Enum.at(comments, 0).content == comment.content
    end
  end
end