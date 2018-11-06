defmodule DiscussWeb.Auth.AuthControllerTest do
  use DiscussWeb.ConnCase

  test "redirects user to github auth", %{conn: conn} do
    conn = get(conn, auth_path(conn, :request, "github"))
    
    assert redirected_to(conn, 302)
  end
end

