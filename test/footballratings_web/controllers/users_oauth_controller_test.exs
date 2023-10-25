defmodule FootballratingsWeb.UsersOauthControllerTest do
  use FootballratingsWeb.ConnCase
  import Footballratings.AccountsFixtures
  alias Footballratings.Accounts

  describe "callback/1" do
    test "registers a new user", %{conn: conn} do
      ueberauth_auth = %{info: %{email: unique_users_email()}}
      conn = conn |> assign(:ueberauth_auth, ueberauth_auth)

      assert nil == Accounts.get_users_by_email(ueberauth_auth.info.email)
      get(conn, "/auth/google/callback") |> response(302)

      assert nil != Accounts.get_users_by_email(ueberauth_auth.info.email)
    end

    test "fails to register user if email is invalid", %{conn: conn} do
      ueberauth_auth = %{info: %{email: "invalidemail"}}

      conn = conn |> assign(:ueberauth_auth, ueberauth_auth) |> get("/auth/google/callback")

      assert redirected_to(conn) == ~p"/"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Failed fetching/creating user"
      assert nil == Accounts.get_users_by_email(ueberauth_auth.info.email)
    end

    test "fails with invalid parameters", %{conn: conn} do
      conn =
        conn
        |> assign(:ueberauth_auth, %{invalid: "params"})
        |> get("/auth/google/callback")

      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "Auth provider did not return valid information"
    end
  end
end
