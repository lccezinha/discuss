defmodule DiscussWeb.CommentsChannelTest do
  use DiscussWeb.ChannelCase

  alias Discuss.Factory
  alias DiscussWeb.CommentsChannel

  def topic_factory do
    Factory.insert(:topic)
  end

  setup do
    {:ok, socket} = connect(DiscussWeb.UserSocket, %{})

    {:ok, socket: socket}
  end

  describe "join" do
    test "join comments channel", %{socket: socket} do
      topic = topic_factory()
      assert {:ok, reply, _socket} = subscribe_and_join(socket, "comments:#{topic.id}", %{})
    end
  end

  # describe "handle_in" do
  #   test "ping replies with status ok", %{socket: socket} do
  #     ref = push(socket, "ping", %{"content" => "some content"})
  #     assert_reply(ref, :ok, %{"content" => "some content"})
  #   end
  # end
end