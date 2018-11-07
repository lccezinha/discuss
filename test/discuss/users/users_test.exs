defmodule Discuss.UsersTest do
  use Discuss.DataCase

  alias Discuss.Factory
  alias Discuss.Users
  alias Discuss.Users.User

  def user_fixture(attrs \\ %{}) do
    Factory.insert(:user, attrs)
  end

  test "insert_or_find/1 with new and valid data must create a new user" do
    params = %{email: "email@example.org", name: "Dev", token: "token123"}

    {:ok, user} = Users.insert_or_find(params)

    assert user.email == params.email
    assert user.name == params.name
    assert user.token == params.token
  end

  test "insert_or_find/1 with new and invalid data must (email) raise error" do
    params = %{email: "", name: "Dev", token: "token"}

    {:error, result} = Users.insert_or_find(params)

    refute result.valid?
    assert "can't be blank" in errors_on(result).email
  end

  test "insert_or_find/1 with new and invalid data must (name) raise error" do
    params = %{email: "email@example.org", name: "", token: "token"}

    {:error, result} = Users.insert_or_find(params)

    refute result.valid?
    assert "can't be blank" in errors_on(result).name
  end

  test "insert_or_find/1 with new and invalid data must (token) raise error" do
    params = %{email: "email@example.org", name: "Dev", token: ""}

    {:error, result} = Users.insert_or_find(params)

    refute result.valid?
    assert "can't be blank" in errors_on(result).token
  end

  test "insert_or_find/1 with an already created user must return this user" do
    params = %{email: "xunda@example.org", name: "name", token: "tokentoken"}
    Users.insert_or_find(params)
    records_total = Repo.one(from u in User, select: count(u.id))

    assert records_total == 1

    {:ok, user} = Users.insert_or_find(params)

    assert user.name == params.name
    assert records_total == 1
  end
end