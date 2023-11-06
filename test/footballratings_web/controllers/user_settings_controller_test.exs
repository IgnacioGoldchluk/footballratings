defmodule FootballratingsWeb.UserSettingsControllerTest do
  use FootballratingsWeb.ConnCase

  setup :register_and_log_in_users

  describe "settings page" do
    test "displays the main page with options", %{conn: conn} do
      html = get(conn, ~p"/user/settings") |> html_response(200)

      assert html =~ "Set username"
      assert html =~ "Upgrade to pro"
      assert html =~ "Purchase history"
    end
  end
end
