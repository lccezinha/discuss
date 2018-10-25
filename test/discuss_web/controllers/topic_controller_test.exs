defmodule DiscussWeb.TopicControllerTest do
  use DiscussWeb.ConnCase

  @valid_params %{title: "My Title"}
  @invalid_params %{title: ""}

  test "GET /topics/new", %{conn: conn} do
    conn = get(conn, topic_path(conn, :new))

    assert html_response(conn, 200)
  end

  test "POST /topics with valid data", %{conn: conn} do
    conn = post(conn, topic_path(conn, :create), topic: @valid_params)

    assert redirected_to(conn) == topic_path(conn, :new)
  end

  test "POST /topics with invalid data", %{conn: conn} do
    conn = post(conn, topic_path(conn, :create), topic: @invalid_params)

    assert html_response(conn, 200) =~ "New User"
  end
end
