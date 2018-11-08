defmodule DiscussWeb.Auth.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.Users

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    signin(conn, auth)
  end

  defp signin(conn, auth) do
    params = %{
      email: auth.info.email,
      name: auth.info.name,
      token: auth.credentials.token
    }

    case Users.insert_or_find(params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User #{user.email} successful log in")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Some shit happen, login failed!")
        |> redirect(to: topic_path(conn, :index))
    end
  end
end
