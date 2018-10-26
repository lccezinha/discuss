defmodule Discuss.TopicsTest do
  use Discuss.DataCase

  alias Discuss.Factory
  alias Discuss.Topics

  def topic_fixture(attrs \\ %{}) do
    Factory.insert(:topic, attrs)
  end

  test "list_topics/1 with empty data" do
    records = Topics.list_topics()

    assert records == []
  end

  test "list_topics/1 with filled array data" do
    topic_one = topic_fixture()
    topic_two = topic_fixture(%{title: "Second title"})

    topics = Topics.list_topics()

    ids = Enum.map(topics, fn(topic) -> topic.id end)

    refute topics == []
    assert topic_one.id in ids
    assert topic_two.id in ids
  end

  test "create_topic/1 with valid data must create a new topic" do
    params = %{title: "Title"}

    {:ok, topic} = Topics.create_topic(params)

    assert topic.title == params.title
  end

  test "create_topic/1 with invalid data must raise error" do
    params = %{title: ""}

    {:error, result} = Topics.create_topic(params)

    refute result.valid?
    assert "can't be blank" in errors_on(result).title
  end

  test "get_topic/1 with valid data must return a topic" do
    topic_one = topic_fixture()

    record = Topics.get_topic!(topic_one.id)

    assert record.id == topic_one.id
    assert record.title == topic_one.title
  end
end
