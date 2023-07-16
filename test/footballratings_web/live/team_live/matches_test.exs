defmodule FootballratingsWeb.TeamLive.MatchesTest do
  use FootballratingsWeb.ConnCase
  import Phoenix.LiveViewTest
  alias Footballratings.InternalDataFixtures

  setup do
    %{team: InternalDataFixtures.create_team(%{name: "The Team FC"})}
  end

  describe "Matches for a team" do
    test "contains a back to team button that redirects to team page", %{conn: conn, team: team} do
      %{id: team_id, name: team_name} = team

      {:ok, view, html} = live(conn, ~p"/teams/#{team_id}/matches")

      assert html =~ "Back to team"
      assert html =~ team_name

      view |> element("#back-to-team-link") |> render_click()
      path = assert_patch(view)
      assert path =~ "/teams/#{team_id}"
    end

    test "displays all the matches for the team", %{conn: conn, team: team} do
      %{id: team_id} = team

      home = for _ <- 1..3, do: InternalDataFixtures.create_match(%{home_team_id: team_id})
      away = for _ <- 1..3, do: InternalDataFixtures.create_match(%{away_team_id: team_id})
      matches = home ++ away

      other_match = InternalDataFixtures.create_match()

      {:ok, view, _html} = live(conn, ~p"/teams/#{team_id}/matches")

      assert has_element?(view, "#matches-table")
      assert has_element?(view, "#load-more-matches-button")

      refute Enum.all?(matches, fn %{id: match_id} ->
               has_element?(view, "#matches-#{match_id}")
             end)

      view |> element("#load-more-matches-button") |> render_click()

      assert Enum.all?(matches, fn %{id: match_id} ->
               has_element?(view, "#matches-#{match_id}")
             end)

      refute has_element?(view, "#matches-#{other_match.id}")
    end
  end
end
