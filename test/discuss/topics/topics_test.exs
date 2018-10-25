defmodule Discuss.TopicsTest do
  use Discuss.DataCase

  alias Discuss.Repo
  alias Discuss.Topics
  alias Discuss.Topics.Topic

  def topic_fixture(attrs \\ %{title: "My Title"}) do
    changeset = Topic.changeset(%Topic{}, attrs)

    Repo.insert(changeset)
  end

  test "list_topics/1 with empty data" do
    records = Topics.list_topics()

    assert records == []
  end

  test "list_topics/1 with filled array data" do
    {_, topic_one} = topic_fixture()
    {_, topic_two} = topic_fixture(%{title: "Second title"})

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
end
