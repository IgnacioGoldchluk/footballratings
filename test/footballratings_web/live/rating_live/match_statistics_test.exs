defmodule FootballratingsWeb.RatingLive.MatchStatisticsTest do
  alias Footballratings.InternalDataFixtures
  use FootballratingsWeb.ConnCase
  import Phoenix.LiveViewTest

  setup do
    ht = InternalDataFixtures.create_team(%{name: "Botafogo"})
    at = InternalDataFixtures.create_team(%{name: "Palmeiras"})
    match = InternalDataFixtures.create_match(%{home_team_id: ht.id, away_team_id: at.id})

    ht_player = InternalDataFixtures.create_player(%{team_id: ht.id, name: "Di Placido"})
    at_player = InternalDataFixtures.create_player(%{team_id: at.id, name: "Jose Lopez"})

    InternalDataFixtures.create_player_match(%{
      team_id: ht.id,
      player_id: ht_player.id,
      match_id: match.id
    })

    InternalDataFixtures.create_player_match(%{
      team_id: at.id,
      player_id: at_player.id,
      match_id: match.id
    })

    %{match: match, home_team: ht, away_team: at, players: [ht_player, at_player]}
  end

  describe "match statistics" do
    test "contains a back to match button", %{conn: conn, match: match} do
      {:ok, view, html} = live(conn, ~p"/matches/#{match.id}/statistics")

      assert has_element?(view, "#back-to-match-button")
      assert html =~ "Back to match"

      view |> element("#back-to-match-button") |> render_click()
      path = assert_patch(view)
      assert path =~ "/matches/#{match.id}"
    end

    test "contains statistics for both teams", %{
      conn: conn,
      match: match,
      home_team: ht,
      away_team: at
    } do
      {:ok, view, html} = live(conn, ~p"/matches/#{match.id}/statistics")

      assert html =~ ht.name
      assert html =~ at.name

      assert view |> has_element?("#home-team-stats")
      assert view |> has_element?("#away-team-stats")
    end

    test "displays only players for the selected team", %{
      conn: conn,
      match: match,
      home_team: ht,
      away_team: at,
      players: players
    } do
      {:ok, view, _html} = live(conn, ~p"/matches/#{match.id}/statistics")

      new_html = view |> element("#home-team-stats") |> render_click()

      ht_players = Enum.filter(players, fn %{team_id: tid} -> tid == ht.id end)
      at_players = Enum.filter(players, fn %{team_id: tid} -> tid == at.id end)

      assert Enum.all?(ht_players, fn %{name: p_name} -> new_html =~ p_name end)
      refute Enum.any?(at_players, fn %{name: p_name} -> new_html =~ p_name end)

      new_html = view |> element("#away-team-stats") |> render_click()
      assert Enum.all?(at_players, fn %{name: p_name} -> new_html =~ p_name end)
      refute Enum.any?(ht_players, fn %{name: p_name} -> new_html =~ p_name end)
    end
  end
end
