defmodule Footballratings.Ratings.RatingsTest do
  use Footballratings.DataCase

  # Alias instead of import because I don't want to accidentally fill the local namespace.
  alias Footballratings.RatingsFixtures
  alias Footballratings.InternalDataFixtures
  alias Footballratings.AccountsFixtures

  alias Footballratings.Ratings

  describe "ratings" do
    test "create_rating/1 creates a rating" do
      match = InternalDataFixtures.create_match()
      user = AccountsFixtures.users_fixture()

      attrs = %{match_id: match.id, user_id: user.id, team_id: match.home_team_id}
      assert {:ok, match_rating} = Ratings.create_match_ratings(attrs)
      assert match_rating.match_id == attrs[:match_id]
      assert match_rating.user_id == attrs[:user_id]
      assert match_rating.team_id == attrs[:team_id]
    end

    test "create_rating/1 supports same user same match multiple teams" do
      match = InternalDataFixtures.create_match()
      user = AccountsFixtures.users_fixture()

      attrs = %{match_id: match.id, user_id: user.id, team_id: match.home_team_id}
      assert {:ok, match_ratings_1} = Ratings.create_match_ratings(attrs)

      attrs = Map.put(attrs, :team_id, match.away_team_id)
      assert {:ok, match_ratings_2} = Ratings.create_match_ratings(attrs)

      assert match_ratings_2.team_id == match.away_team_id
      assert match_ratings_1.team_id == match.home_team_id
      assert match_ratings_2.id != match_ratings_1.team_id
    end

    test "create_rating/1 fails with duplicate values" do
      match = InternalDataFixtures.create_match()
      user = AccountsFixtures.users_fixture()

      attrs = %{match_id: match.id, user_id: user.id, team_id: match.home_team_id}
      assert {:ok, _valid_match} = Ratings.create_match_ratings(attrs)

      assert {:error, %Ecto.Changeset{}} = Ratings.create_match_ratings(attrs)
    end
  end

  describe "players_ratings" do
    test "create_player_ratings/1 creates a rating for a player" do
      match_ratings = RatingsFixtures.create_match_ratings()
      player = InternalDataFixtures.create_player(%{team_id: match_ratings.team_id})

      attrs = %{score: 8, player_id: player.id, match_rating_id: match_ratings.id}
      assert {:ok, player_ratings} = Ratings.create_player_ratings(attrs)
      assert player_ratings.score == attrs[:score]
      assert player_ratings.player_id == attrs[:player_id]
      assert player_ratings.match_rating_id == attrs[:match_rating_id]
    end

    test "create_player_ratings/1 fails if score out of range" do
      match_ratings = RatingsFixtures.create_match_ratings()
      player = InternalDataFixtures.create_player(%{team_id: match_ratings.team_id})

      attrs = %{score: 11, player_id: player.id, match_rating_id: match_ratings.id}
      assert {:error, %Ecto.Changeset{}} = Ratings.create_player_ratings(attrs)
    end

    test "create_match_and_players_ratings executes successfully in a transaction" do
      match = InternalDataFixtures.create_match()

      players = 1..15 |> Enum.map(&%{id: &1}) |> Enum.map(&InternalDataFixtures.create_player/1)

      team_id = match.away_team_id

      assert {:ok, results} = Ratings.create_match_and_players_ratings(players)
    end
  end
end
