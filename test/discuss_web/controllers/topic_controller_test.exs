defmodule DiscussWeb.TopicControllerTest do
  use DiscussWeb.ConnCase

  test "GET /topics/new", %{conn: conn} do
    conn = get(conn, topic_path(conn, :new))
    assert html_response(conn, 200)
  end
end
