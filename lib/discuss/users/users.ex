defmodule Discuss.Users do
  @moduledoc """
    Users context
  """

  import Ecto.Query, warn: false

  alias Discuss.Repo
  alias Discuss.Users.User

  def insert_or_find(params \\ %{}) do
    case User |> where(email: ^params.email) |> Repo.one() do
      nil ->
        %User{}
        |> User.changeset(params)
        |> Repo.insert()
      user ->
        {:ok, user}
    end
  end
end