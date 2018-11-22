defmodule Discuss.Topics.CommentTest do
  use Discuss.DataCase

  alias Discuss.Factory
  alias Discuss.Topics.Comment

  def topic_factory(attrs \\ %{}) do
    Factory.build(:topic, attrs)
  end

  def user_factory(attrs \\ %{}) do
    Factory.build(:user, attrs)
  end

  def comment_factory(attrs \\ %{}) do
    Factory.build(:comment, attrs)
  end

  describe "validations" do
    test "content must be required" do
      comment = comment_factory(%{content: ""})
      changeset = Comment.changeset(comment, %{})

      assert !changeset.valid?
      assert "can't be blank" in errors_on(changeset).content
    end
  end
end
