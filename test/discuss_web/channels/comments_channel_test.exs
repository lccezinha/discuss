defmodule DiscussWeb.CommentsChannelTest do
  use DiscussWeb.ChannelCase

  alias Discuss.Factory
  alias Discuss.Repo
  alias Discuss.Topics.Comment

  def topic_factory do
    Factory.insert(:topic)
  end

  def user_factory do
    Factory.insert(:user)
  end

  def comment_factory(attrs) do
    Factory.build(:comment, attrs)
  end

  setup do
    {:ok, socket} =
      connect(DiscussWeb.UserSocket, %{
        "token" =>
          "SFMyNTY.g3QAAAACZAAEZGF0YWEFZAAGc2lnbmVkbgYAamOMgGcB.vrKKpBq7RNLhB1JBKEwDSGWw-VeJbJ5D-wSRKmj6aJQ"
      })

    {:ok, socket: socket}
  end

  describe "join" do
    test "join to a topic channel and fetch related comments", %{socket: socket} do
      topic = topic_factory()
      user = user_factory()

      {:ok, comment} = comment_factory(%{topic_id: topic.id, user_id: user.id}) |> Repo.insert()

      assert {:ok, %{comments: comments}, socket} =
               subscribe_and_join(socket, "comments:#{topic.id}", %{})

      assert socket.assigns.topic.id == topic.id
      assert length(comments) == 1
      assert Enum.at(comments, 0).content == comment.content
      assert Enum.at(comments, 0).user_id == comment.user_id
    end
  end

  describe "handle_in" do
    test "receive a valid content and create new comment", %{socket: socket} do
      topic = topic_factory()
      user = user_factory()
      {:ok, _payload, socket} = subscribe_and_join(socket, "comments:#{topic.id}", %{})

      push(socket, "comments:add", %{"content" => "my content"})

      broadcast_event = "comments:#{topic.id}:new"
      broadcast_payload = %{comment: get_last_comment()}

      assert_broadcast(^broadcast_event, ^broadcast_payload)
    end

    test "receive an invalid content and create new comment", %{socket: socket} do
      topic = topic_factory()
      {:ok, _payload, socket} = subscribe_and_join(socket, "comments:#{topic.id}", %{})

      ref = push(socket, "comments:add", %{"content" => ""})
      assert_reply(ref, :error, %{errors: reason})
    end

    defp get_last_comment do
      import Ecto.Query

      Discuss.Repo.one(from(c in Comment, order_by: [desc: c.id], limit: 1))
    end
  end
end
