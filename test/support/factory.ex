defmodule Discuss.Factory do
  use ExMachina.Ecto, repo: Discuss.Repo

  alias Discuss.Topics.Topic
  alias Discuss.Topics.User

  def topic_factory do
    %Topic{title: "My title"}
  end

    def user_factory do
    %User{
      email: "dev@example.org",
      name: "Developer",
      token: "some-token-123"
    }
  end
end
