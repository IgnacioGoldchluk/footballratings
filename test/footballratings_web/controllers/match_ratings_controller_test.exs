defmodule FootballratingsWeb.MatchRatingsControllerTest do
  use FootballratingsWeb.ConnCase
  alias Footballratings.InternalDataFixtures
  alias Footballratings.RatingsFixtures
  import Footballratings.AccountsFixtures

  alias Footballratings.Ratings

  describe "match ratings" do
    test "renders ratings for every player", %{conn: conn} do
      users = %{id: users_id} = users_fixture()
      match = %{id: match_id, home_team_id: team_id} = InternalDataFixtures.create_match()
      players = for _ <- 1..15, do: InternalDataFixtures.create_player(%{team_id: team_id})

      Enum.each(players, fn player ->
        InternalDataFixtures.create_player_match(%{
          player_id: player.id,
          team_id: player.team_id,
          match_id: match_id
        })
      end)

      # Random scores
      scores = RatingsFixtures.random_scores(players)

      # Create the ratings
      assert {:ok, %{id: match_ratings_id}} =
               Ratings.create_match_and_players_ratings(
                 players,
                 scores,
                 team_id,
                 match_id,
                 users_id
               )

      response_body = get(conn, "/ratings/show/#{match_ratings_id}") |> response(200)

      assert response_body =~ users.username

      Enum.each(players, fn player ->
        assert response_body =~ player.name
      end)
    end
  end
end
