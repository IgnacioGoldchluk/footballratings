defmodule FootballratingsWeb.UsersSessionController do
  use FootballratingsWeb, :controller

  alias FootballratingsWeb.UsersAuth

  def delete(conn, _params) do
    conn
    |> UsersAuth.log_out_users()
  end
end
