defmodule DiscussWeb.Auth.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  def callback(conn, params) do
    IO.inspect("\n @@@@ ")
    IO.inspect(conn.assigns)
    IO.inspect("\n @@@@ ")
    IO.inspect(params)
    IO.inspect("\n @@@@ ")

    conn
    |> resp(200, "{}")
  end
end
