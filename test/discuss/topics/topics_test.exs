defmodule Discuss.TopicsTest do
  use Discuss.DataCase

  import Ecto.Query

  alias Discuss.Factory
  alias Discuss.Repo
  alias Discuss.Topics
  alias Discuss.Topics.Topic

  def topic_factory(attrs \\ %{}) do
    Factory.insert(:topic, attrs)
  end

  def user_factory do
    Factory.insert(:user)
  end

  test "list_topics/1 with empty data" do
    records = Topics.list_topics()

    assert records == []
  end

  test "list_topics/1 with filled array data" do
    topic_one = topic_factory()
    topic_two = topic_factory()

    topics = Topics.list_topics()

    ids = Enum.map(topics, fn topic -> topic.id end)

    refute topics == []
    assert topic_one.id in ids
    assert topic_two.id in ids
  end

  test "create_topic/1 with valid data must create a new topic" do
    user = user_factory()
    params = %{title: "Title", user_id: user.id}

    {:ok, topic} = Topics.create_topic(params)

    assert topic.title == params.title
    assert topic.user_id == params.user_id
  end

  test "create_topic/1 with invalid data must raise error" do
    params = %{title: ""}

    {:error, result} = Topics.create_topic(params)

    refute result.valid?
    assert "can't be blank" in errors_on(result).title
  end

  test "get_topic/1 with valid data must return a topic" do
    topic_one = topic_factory()

    record = Topics.get_topic!(topic_one.id)

    assert record.id == topic_one.id
    assert record.title == topic_one.title
  end

  test "update_post/2 with valid data must updates the topic" do
    topic = topic_factory()
    user_id = topic.user_id
    valid_params = %{title: "Other title"}

    assert {:ok, topic} = Topics.update_topic(topic, valid_params)
    assert topic.title == "Other title"
    assert topic.user_id == user_id
  end

  test "update_post/2 with invalid data must not updates the topic" do
    topic = topic_factory()
    invalid_params = %{title: ""}

    assert {:error, %Ecto.Changeset{}} = Topics.update_topic(topic, invalid_params)

    result = Topics.get_topic!(topic.id)

    assert topic.id == result.id
    assert topic.title == result.title
    assert topic.user_id == result.user_id
  end

  test "delete_topic/1 with valid data must delete the topic" do
    topic = topic_factory()

    assert {:ok, %Topic{}} = Topics.delete_topic(topic)
    assert Topics.list_topics() == []
  end

  test "create_comment/1 with valid data must create a comment related with topic" do
    assert Repo.one(from(c in "comments", select: count(c.id))) == 0

    topic = topic_factory()
    user = user_factory()
    Topics.create_comment(topic, user.id, "some comment")
    topic = Topics.get_topic!(topic.id) |> Repo.preload(:comments)

    assert Repo.one(from(c in "comments", select: count(c.id))) == 1
    assert Enum.at(topic.comments, 0).topic_id == topic.id
    assert Enum.at(topic.comments, 0).user_id == user.id
  end

  test "create_comment/1 with invalid data must not create a comment and return error" do
    {:error, result} =
      topic_factory()
      |> Topics.create_comment(1, "")

    refute result.valid?
    assert "can't be blank" in errors_on(result).content
  end

  test "get_topic_with_comments_preload/1" do
    topic_data = topic_factory()
    user = user_factory()
    Topics.create_comment(topic_data, user.id, "some comment")
    topic = Topics.get_topic_with_comments_preload(topic_data.id)

    assert length(topic.comments) == 1
    assert Enum.at(topic.comments, 0).content == "some comment"
  end
end
