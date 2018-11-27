defmodule Discuss.CommentsChannel do
  use DiscussWeb, :channel

  def join(name, _auth_msg, socket) do
    IO.inspect(name)
    {:ok, %{hey: "there"}, socket}
  end

  def handle_in(name, message, socket) do
    {:reply, :ok, socket}
  end
end