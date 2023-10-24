defmodule FootballratingsWeb.UsersSessionControllerTest do
  use FootballratingsWeb.ConnCase, async: true

  import Footballratings.AccountsFixtures

  setup do
    %{users: users_fixture()}
  end

  describe "DELETE /users/log_out" do
    test "logs the users out", %{conn: conn, users: users} do
      conn = conn |> log_in_users(users) |> delete(~p"/users/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :users_token)
    end

    test "succeeds even if the users is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/users/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :users_token)
    end
  end
end
