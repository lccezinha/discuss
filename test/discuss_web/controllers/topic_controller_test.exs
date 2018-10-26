defmodule DiscussWeb.TopicControllerTest do
  use DiscussWeb.ConnCase

  alias Discuss.Factory

  def topic_fixture(attrs \\ %{}) do
    Factory.insert(:topic, attrs)
  end

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

    assert html_response(conn, 200) =~ "New Topic"
  end

  test "GET /topics/ID/edit with valid id must show the edit form", %{conn: conn} do
    topic = topic_fixture()

    conn = get(conn, topic_path(conn, :edit, topic))

    assert html_response(conn, 200) =~ "Edit Topic"
  end

  test "PUT /topics/ID with valid data must update the topic data and redirect to index", %{conn: conn} do
    topic = topic_fixture()
    params = %{title: "Other title"}

    conn = put(conn, topic_path(conn, :update, topic), topic: params)

    assert get_flash(conn, :info) == "Topic edited!"
    assert redirected_to(conn) == topic_path(conn, :index)
  end

  test "PUT /topics/ID with invalid data must not update topic and stay in form", %{conn: conn} do
    topic = topic_fixture()

    conn = put(conn, topic_path(conn, :update, topic), topic: @invalid_params)

    assert html_response(conn, 200) =~ "Edit Topic"
  end
end
