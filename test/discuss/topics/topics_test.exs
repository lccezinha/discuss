defmodule Discuss.TopicsTest do
  use Discuss.DataCase

  alias Discuss.Topics
  alias Discuss.Topics.Topic

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
