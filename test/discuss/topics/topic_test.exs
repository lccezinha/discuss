defmodule Discuss.Topics.TopicTest do
  use Discuss.DataCase
  alias Discuss.Topics.Topic

  describe "validations" do
    test "title must be required" do
      topic = %Topic{title: ""}
      changeset = Topic.changeset(topic, %{})

      assert !changeset.valid?
      assert "can't be blank" in errors_on(changeset).title
    end
  end
end
