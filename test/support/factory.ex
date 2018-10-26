defmodule Discuss.Factory do
  use ExMachina.Ecto, repo: Discuss.Repo

  alias Discuss.Topics.Topic

  def topic_factory do
    %Topic{title: "My title"}
  end
end
