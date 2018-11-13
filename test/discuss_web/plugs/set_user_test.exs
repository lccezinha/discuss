defmodule DiscussWeb.Plugs.SetUserTest do
  use DiscussWeb.ConnCase

  alias Discuss.Factory
  alias DiscussWeb.Plugs.SetUser

  def user_factory do
    Factory.insert(:user)
  end

  test "init/1 must return params" do
    assert %{} == SetUser.init(%{})
  end

  test "call/2 with user in sessions must assigns user to conn assings struct", %{conn: conn} do
    user_data = user_factory()

    conn =
      conn
      |> Plug.Test.init_test_session(user_id: user_data.id)

    assert %{assigns: %{user: user}} = SetUser.call(conn, %{})
    
    assert user.id == user_data.id
  end

  test "call/2 without user in sessions must assigns NIL to conn assings struct", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(user_id: nil)

    assert %{assigns: %{user: user}} = SetUser.call(conn, %{})
    
    assert user == nil
  end
end
