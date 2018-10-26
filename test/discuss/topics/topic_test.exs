defmodule Discuss.Topics.TopicTest do
  use Discuss.DataCase

  alias Discuss.Factory
  alias Discuss.Topics.Topic

  def topic_fixture(attrs \\ %{}) do
    Factory.build(:topic, attrs)
  end

  describe "validations" do
    test "title must be required" do
      topic = topic_fixture(%{title: ""})
      changeset = Topic.changeset(topic, %{})

      assert !changeset.valid?
      assert "can't be blank" in errors_on(changeset).title
    end
  end
end
