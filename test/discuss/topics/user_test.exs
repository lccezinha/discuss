defmodule Discuss.Topics.UserTest do
  use Discuss.DataCase

  alias Discuss.Factory
  alias Discuss.Topics.User

  def user_fixture(attrs \\ %{}) do
    Factory.build(:user, attrs)
  end

  describe "validations" do
    test "email must be required" do
      user = user_fixture(%{email: ""})
      changeset = User.changeset(user, %{})

      assert !changeset.valid?
      assert "can't be blank" in errors_on(changeset).email
    end

    test "name must be required" do
      user = user_fixture(%{name: ""})
      changeset = User.changeset(user, %{})

      assert !changeset.valid?
      assert "can't be blank" in errors_on(changeset).name
    end

    test "token must be required" do
      user = user_fixture(%{token: ""})
      changeset = User.changeset(user, %{})

      assert !changeset.valid?
      assert "can't be blank" in errors_on(changeset).token
    end
  end
end
