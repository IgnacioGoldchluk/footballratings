defmodule FootballratingsWeb.PlayerLive.ShowTest do
  alias Footballratings.RatingsFixtures
  alias Footballratings.InternalDataFixtures
  use FootballratingsWeb.ConnCase
  import Phoenix.LiveViewTest

  setup do
    team = %{id: tid} = InternalDataFixtures.create_team(%{name: "Botafogo"})

    player = %{id: p_id} = InternalDataFixtures.create_player(%{name: "Di Placido", team_id: tid})

    home_match = %{id: hm_id} = InternalDataFixtures.create_match(%{home_team_id: team.id})
    away_match = %{id: am_id} = InternalDataFixtures.create_match(%{away_team_id: team.id})

    InternalDataFixtures.create_player_match(%{team_id: tid, player_id: p_id, match_id: hm_id})
    InternalDataFixtures.create_player_match(%{team_id: tid, player_id: p_id, match_id: am_id})

    mr1 = RatingsFixtures.create_match_ratings(%{match_id: hm_id})
    mr2 = RatingsFixtures.create_match_ratings(%{match_id: am_id})

    RatingsFixtures.create_player_rating(%{score: 5, player_id: p_id, match_ratings_id: mr1.id})
    RatingsFixtures.create_player_rating(%{score: 7, player_id: p_id, match_ratings_id: mr2.id})

    %{player: player, matches: [home_match, away_match]}
  end

  describe "player home page" do
    test "renders with matches", %{conn: conn, player: player, matches: matches} do
      {:ok, view, html} = live(conn, ~p"/players/#{player.id}")

      assert html =~ player.name
      assert Enum.all?(matches, fn %{id: mid} -> has_element?(view, "#matches-#{mid}") end)
      assert view |> has_element?("#player-stats-chart")
    end
  end
end
