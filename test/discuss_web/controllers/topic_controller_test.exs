defmodule DiscussWeb.TopicControllerTest do
  use DiscussWeb.ConnCase

  @valid_params %{title: "My Title"}
  @invalid_params %{title: ""}

  test "GET /topics or /", %{conn: conn} do
    conn = get(conn, topic_path(conn, :index))

    assert html_response(conn, 200) =~ "Listing Topics"
  end

  test "GET /topics/new", %{conn: conn} do
    conn = get(conn, topic_path(conn, :new))

    assert html_response(conn, 200)
  end

  test "POST /topics with valid data must create a new topic and redirect to index path", %{conn: conn} do
    conn = post(conn, topic_path(conn, :create), topic: @valid_params)

    assert get_flash(conn, :info) == "Topic created!"
    assert redirected_to(conn) == topic_path(conn, :index)
  end

  test "POST /topics with invalid data must redirect ", %{conn: conn} do
    conn = post(conn, topic_path(conn, :create), topic: @invalid_params)

    assert html_response(conn, 200) =~ "New User"
  end
end
