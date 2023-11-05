defmodule FootballratingsWeb.SubscriptionsControllerTest do
  import Footballratings.BillingFixtures
  import Footballratings.AccountsFixtures

  use FootballratingsWeb.ConnCase

  describe "subscriptions page" do
    setup do
      user = users_fixture()
      statuses = [:active, :pending, :cancelled, :paused]

      subscriptions =
        statuses
        |> Enum.map(&subscription_fixture(%{status: &1, users_id: user.id}))

      %{user: user, subscriptions: subscriptions}
    end

    test "does not render if not logged in", %{conn: conn} do
      conn = get(conn, ~p"/user/subscriptions")
      assert redirected_to(conn) == ~p"/"
    end

    test "shows the subscriptions for a logged in user", %{conn: conn, user: user} do
      conn = conn |> log_in_users(user) |> get(~p"/user/subscriptions")

      html = html_response(conn, 200)

      # Assert all statuses are displayed
      assert html =~ "active"
      assert html =~ "pending"
      assert html =~ "paused"
      assert html =~ "cancelled"

      # Assert column tables
      assert html =~ "Status"
      assert html =~ "Created at"
      assert html =~ "Last updated"
    end
  end
end
