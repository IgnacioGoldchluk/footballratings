defmodule FootballratingsWeb.UserOauthController do
  use FootballratingsWeb, :controller

  alias Footballratings.Accounts
  alias FootballratingsWeb.UsersAuth

  plug Ueberauth

  @rand_pw_length 32

  def callback(%{assigns: %{ueberauth_auth: %{info: user_info}}} = conn, _params) do
    user_params = %{email: user_info.email, password: random_password()}

    case Accounts.fetch_or_create_user(user_params) do
      {:ok, user} -> UsersAuth.log_in_users(conn, user)
      _ -> conn |> put_flash(:error, "Failed fetching/creating user") |> redirect(to: ~p"/")
    end
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Auth provider did not return valid information")
    |> redirect(to: ~p"/")
  end

  defp random_password(), do: :crypto.strong_rand_bytes(@rand_pw_length) |> Base.encode64()
end
