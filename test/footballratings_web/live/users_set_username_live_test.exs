defmodule FootballratingsWeb.UsersSetUsernameLiveTest do
  use FootballratingsWeb.ConnCase
  import Phoenix.LiveViewTest
  import Footballratings.AccountsFixtures

  setup do
    %{users: users_fixture(username: nil)}
  end

  describe "Main page" do
    test "Prompts for username creation", %{conn: conn, users: users} do
      {:ok, _view, html} = conn |> log_in_users(users) |> live(~p"/user/settings")

      assert html =~ "Set username"
      assert html =~ "Set a unique username to continue"
    end

    test "Happy path", %{conn: conn, users: users} do
      {:ok, view, html} = conn |> log_in_users(users) |> live(~p"/user/settings")

      # Initial render, shouldn't show availability
      refute html =~ "Username is available!"

      # Set the username and expect it to be available
      view
      |> form("#username-form", %{"set-username" => %{username: "Valid_User1"}})
      |> render_change()

      new_html = view |> element("#validate-username-available") |> render_click()

      assert new_html =~ "Username is available!"

      # Send the form, should be redirected to the home page
      view
      |> form("#username-form")
      |> render_submit()

      {path, _} = assert_redirect(view)
      assert path =~ "/"

      # We already set the username and cannot change it!
      {:ok, _view, html} = conn |> log_in_users(users) |> live(~p"/user/settings")

      assert "You already set your username"
      refute html =~ "Set username"
    end

    test "duplicated username", %{conn: conn, users: users} do
      duplicated = "TakenUser"
      users_fixture(%{username: duplicated})

      {:ok, view, _html} = conn |> log_in_users(users) |> live(~p"/user/settings")

      view
      |> form("#username-form", %{"set-username" => %{username: duplicated}})
      |> render_change()

      html = view |> element("#validate-username-available") |> render_click()

      refute html =~ "Username is available!"
      assert html =~ "Username already taken :("
    end
  end
end
