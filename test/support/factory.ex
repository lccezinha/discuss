defmodule Discuss.Factory do
  use ExMachina.Ecto, repo: Discuss.Repo

  alias Discuss.Topics.{Topic, Comment}
  alias Discuss.Users.User

  def topic_factory do
    user = build(:user)

    %Topic{
      title: "My title",
      user: user
    }
  end

  def user_factory do
    %User{
      email: "dev@example.org",
      name: "Developer",
      token: "some-token-123"
    }
  end

  def comment_factory do
    user = build(:user)

    %Comment{
      content: "My content",
      user: user,
      topic: nil
    }
  end
end
