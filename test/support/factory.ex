defmodule Discuss.Factory do
  use ExMachina.Ecto, repo: Discuss.Repo

  alias Discuss.Topics.Topic
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
end
