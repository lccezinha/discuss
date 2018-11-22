defmodule DiscussWeb.TopicControllerTest do
  use DiscussWeb.ConnCase

  alias Discuss.Factory

  def topic_factory(attrs \\ %{}) do
    Factory.insert(:topic, attrs)
  end

  def user_factory do
    Factory.insert(:user)
  end

  @valid_params %{title: "My Title"}
  @invalid_params %{title: ""}

  setup %{conn: conn} do
    user_data = user_factory()

    conn =
      conn
      |> Plug.Test.init_test_session(user_id: user_data.id)
      |> DiscussWeb.Plugs.SetUser.call(%{})

    {:ok, conn: conn}
  end

  test "GET /topics or /", %{conn: conn} do
    conn = get(conn, topic_path(conn, :index))

    assert html_response(conn, 200) =~ "Listing Topics"
  end

  test "GET /topics/new", %{conn: conn} do
    conn = get(conn, topic_path(conn, :new))

    assert html_response(conn, 200)
  end

  describe "POST /topics" do
    test "with valid data must create a new topic and redirect to index path", %{conn: conn} do
      conn = post(conn, topic_path(conn, :create), topic: @valid_params)

      assert get_flash(conn, :info) == "Topic created!"
      assert redirected_to(conn) == topic_path(conn, :index)
    end

    test "with invalid data must redirect ", %{conn: conn} do
      conn = post(conn, topic_path(conn, :create), topic: @invalid_params)

      assert html_response(conn, 200) =~ "New Topic"
    end
  end

  describe "GET /topics/ID/edit" do
    test "with valid id must show the edit form", %{conn: conn} do
      topic = topic_factory(%{user: conn.assigns.user})

      conn = get(conn, topic_path(conn, :edit, topic))

      assert html_response(conn, 200) =~ "Edit Topic"
    end

    test "redirect to root when current user is not topic owner", %{conn: conn} do
      user_one = user_factory()
      user_two = user_factory()
      topic = topic_factory(%{user: user_one})

      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user_two.id)
        |> DiscussWeb.Plugs.SetUser.call(%{})
        |> get(topic_path(conn, :edit, topic))
      
      assert get_flash(conn, :error) == "You're not the owner of this topic!"
      assert redirected_to(conn) == topic_path(conn, :index)
      assert conn.halted()
    end
  end

  describe "PUT /topics/ID" do
    test "with valid data must update the topic data and redirect to index", %{conn: conn} do
      user_one = user_factory()
      topic = topic_factory(%{user: user_one})
      params = %{title: "Other title"}

      conn = put(conn, topic_path(conn, :update, topic), topic: params)

      # assert get_flash(conn, :info) == "Topic edited!"
      assert redirected_to(conn) == topic_path(conn, :index)
    end

    test "with invalid data must not update topic and stay in form", %{conn: conn} do
      topic = topic_factory(%{user: conn.assigns.user})

      conn = put(conn, topic_path(conn, :update, topic), topic: @invalid_params)

      assert html_response(conn, 200) =~ "Edit Topic"
    end

    test "redirect to root when current user is not topic owner", %{conn: conn} do
      user_one = user_factory()
      user_two = user_factory()
      topic = topic_factory(%{user: user_one})

      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user_two.id)
        |> DiscussWeb.Plugs.SetUser.call(%{})
        |> put(topic_path(conn, :update, topic), topic: @valid_params)
      
      assert get_flash(conn, :error) == "You're not the owner of this topic!"
      assert redirected_to(conn) == topic_path(conn, :index)
      assert conn.halted()
    end
  end

  describe "DELETE /topics/id" do
    test "with valid data must delete topic", %{conn: conn} do
      user_one = user_factory()
      topic = topic_factory(%{user: user_one})

      conn = delete(conn, topic_path(conn, :delete, topic))

      #assert get_flash(conn, :info) == "Topic deleted!"
      assert redirected_to(conn) == topic_path(conn, :index)
    end

    test "redirect to root when current user is not topic owner", %{conn: conn} do
      user_one = user_factory()
      user_two = user_factory()
      topic = topic_factory(%{user: user_one})

      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user_two.id)
        |> DiscussWeb.Plugs.SetUser.call(%{})
        |> delete(topic_path(conn, :delete, topic))
      
      assert get_flash(conn, :error) == "You're not the owner of this topic!"
      assert redirected_to(conn) == topic_path(conn, :index)
      assert conn.halted()
    end
  end
end
