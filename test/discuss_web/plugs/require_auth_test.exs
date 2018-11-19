defmodule DiscussWeb.Plugs.RequireAuthTest do
  use DiscussWeb.ConnCase

  alias Discuss.Factory
  alias DiscussWeb.Plugs.RequireAuth

  def user_factory do
    Factory.insert(:user)
  end

  test "init/1 must return params" do
    assert nil == RequireAuth.init(%{})
  end

  test "call/2 with a user in assign struct must forward the conn request", %{conn: conn} do
    user_data = user_factory()

    conn =
      conn
      |> assign(:user, user_data)

    assert conn == RequireAuth.call(conn, %{})
  end

  test "call/2 without a user in a assign struct must redirect to root and halt request", %{conn: conn} do
    conn =
      conn
      |> assign(:user, nil)
      |> bypass_through(DiscussWeb.Router, :browser)
      |> get("/")
      |> RequireAuth.call(%{})

    assert get_flash(conn, :error) == "You must be logged in!"
    assert redirected_to(conn) == topic_path(conn, :index)
    assert conn.halted()
  end
end
