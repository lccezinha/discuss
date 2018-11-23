defmodule Discuss.CommentsChannel do
  use DiscussWeb, :channel

  def join(name, _auth_msg, socket) do
    IO.puts("@@@")
    IO.puts(name)
    
    {:ok, %{hey: "there"}, socket}
  end

  def handle_in() do
  end
end