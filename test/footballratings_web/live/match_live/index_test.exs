defmodule FootballratingsWeb.MatchLive.IndexTest do
  use FootballratingsWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Footballratings.InternalDataFixtures

  describe "index" do
    test "renders properly with search and clear buttons", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/matches")

      assert has_element?(view, "#search-button")
      assert has_element?(view, "#clear-button")
    end

    test "displays matches according to search parameters and clears", %{conn: conn} do
      %{id: team_id} = InternalDataFixtures.create_team(%{name: "Botafogo"})
      match = InternalDataFixtures.create_match(%{home_team_id: team_id})
      other_match = InternalDataFixtures.create_match()
      {:ok, view, _html} = live(conn, ~p"/matches")

      new_html =
        view
        |> form("#search_matches", %{search: %{home_team: "Botafogo", league: "First Division"}})
        |> render_submit()

      assert new_html =~ "Botafogo"
      assert has_element?(view, "#matches-#{match.id}")
      refute has_element?(view, "#matches-#{other_match.id}")

      new_html = view |> element("#clear-button") |> render_click()
      refute new_html =~ "Botafogo"
      refute has_element?(view, "#matches-#{match.id}")
    end

    test "does not search for matches when invalid parameters", %{conn: conn} do
      league = InternalDataFixtures.create_league(%{name: "First Division"})
      %{id: team_id} = InternalDataFixtures.create_team(%{name: "Botafogo"})
      InternalDataFixtures.create_match(%{league_id: league.id, away_team_id: team_id})

      {:ok, view, _html} = live(conn, ~p"/matches")

      new_html =
        view
        |> form("#search_matches", %{search: %{before: "Invalid Date", league: league.name}})
        |> render_change()

      assert new_html =~ "is invalid"

      assert_raise(
        ArgumentError,
        "cannot click element \"#search-button\" because it is disabled",
        fn ->
          view |> element("#search-button") |> render_click()
        end
      )
    end
  end
end
