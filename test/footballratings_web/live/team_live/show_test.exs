defmodule FootballratingsWeb.TeamLive.ShowTest do
  alias Footballratings.RatingsFixtures
  alias Footballratings.AccountsFixtures
  alias Footballratings.InternalDataFixtures
  use FootballratingsWeb.ConnCase

  import Phoenix.LiveViewTest

  setup do
    %{team: InternalDataFixtures.create_team(%{name: "The Team FC"})}
  end

  describe "Main team page" do
    test "renders and displays the team name", %{conn: conn, team: team} do
      %{id: team_id, name: team_name} = team
      {:ok, _lv, html} = live(conn, ~p"/teams/#{team_id}")

      assert html =~ team_name
    end

    test "contains players links", %{conn: conn, team: team} do
      %{id: team_id} = team
      {:ok, view, html} = live(conn, ~p"/teams/#{team_id}")

      assert html =~ "Players"

      view |> element("#players-link") |> render_click()
      path = assert_patch(view)
      assert path =~ "/teams/#{team_id}/players"
    end

    test "contains matches links", %{conn: conn, team: team} do
      %{id: team_id} = team
      {:ok, view, html} = live(conn, ~p"/teams/#{team_id}")

      assert html =~ "Matches"

      view |> element("#matches-link") |> render_click()
      path = assert_patch(view)
      assert path =~ "/teams/#{team_id}/matches"
    end

    test "updates total matches when receiving a new match event", %{conn: conn, team: team} do
      %{id: team_id} = team
      {:ok, view, _html} = live(conn, ~p"/teams/#{team_id}")

      assert view |> element("#total-matches") |> render() =~ "0"

      send(view.pid, %{"type" => "new_match", "match_id" => "123"})

      # Give it some time
      :timer.sleep(5)

      # Number of matches was updated
      assert view |> element("#total-matches") |> render() =~ "1"

      # New element streamed to the view
      assert has_element?(view, "#match-123")
    end

    test "sending a new rating re-assigns the total-ratings and total-matches", %{
      conn: conn,
      team: team
    } do
      %{id: team_id} = team
      {:ok, view, _html} = live(conn, ~p"/teams/#{team_id}")

      assert view |> element("#total-ratings") |> render() =~ "0"
      assert view |> element("#total-matches") |> render() =~ "0"

      %{id: users_id} = AccountsFixtures.users_fixture()
      %{id: match_id} = InternalDataFixtures.create_match(%{home_team_id: team_id})

      RatingsFixtures.create_match_ratings(%{
        users_id: users_id,
        match_id: match_id,
        team_id: team_id
      })

      send(view.pid, %{"type" => "new_rating", "match_id" => "123"})
      :timer.sleep(10)

      assert view |> element("#total-ratings") |> render() =~ "1"
      assert view |> element("#total-matches") |> render() =~ "1"
    end
  end
end
