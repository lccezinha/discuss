defmodule DiscussWeb.Plugs.SetUser do
  @moduledoc """
    Plug to set user_id on conn session
  """

  use Phoenix.Controller, namespace: DiscussWeb
  import Plug.Conn

  alias Discuss.Repo
  alias Discuss.Users.User

  def init(params), do: params

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    
    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)
      true ->
        assign(conn, :user, nil)
    end
  end
end
