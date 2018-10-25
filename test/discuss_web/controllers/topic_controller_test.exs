defmodule DiscussWeb.TopicControllerTest do
  use DiscussWeb.ConnCase

  test "GET /topics/new", %{conn: conn} do
    conn = get(conn, topic_path(conn, :new))

    assert html_response(conn, 200)
  end

  test "POST /topics with valid data", %{conn: conn} do
    params = %{title: "My Title"}

    conn = post(conn, topic_path(conn, :create), topic: params)

    assert redirected_to(conn) == topic_path(conn, :new)
  end

  # test "POST /topics with invalid data", %{conn: conn} do
  #   conn = post(conn, topic_path(conn, :create))
  #
  #   assert response(conn, 200)
  # end
end
