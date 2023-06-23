defmodule Footballratings.Ratings.RatingsTest do
  use Footballratings.DataCase

  # Alias instead of import because I don't want to accidentally fill the local namespace.
  alias Footballratings.RatingsFixtures
  alias Footballratings.InternalDataFixtures
  alias Footballratings.AccountsFixtures

  alias Footballratings.Ratings
  alias Footballratings.FootballInfo

  describe "ratings" do
    test "create_rating/1 creates a rating" do
      match = InternalDataFixtures.create_match()
      user = AccountsFixtures.users_fixture()

      attrs = %{match_id: match.id, users_id: user.id, team_id: match.home_team_id}
      assert {:ok, match_rating} = Ratings.create_match_ratings(attrs)
      assert match_rating.match_id == attrs[:match_id]
      assert match_rating.users_id == attrs[:users_id]
      assert match_rating.team_id == attrs[:team_id]
    end

    test "create_rating/1 supports same user same match multiple teams" do
      match = InternalDataFixtures.create_match()
      user = AccountsFixtures.users_fixture()

      attrs = %{match_id: match.id, users_id: user.id, team_id: match.home_team_id}
      assert {:ok, match_ratings_1} = Ratings.create_match_ratings(attrs)

      attrs = Map.put(attrs, :team_id, match.away_team_id)
      assert {:ok, match_ratings_2} = Ratings.create_match_ratings(attrs)

      assert match_ratings_1.users_id == user.id
      assert match_ratings_2.users_id == user.id
      assert match_ratings_2.team_id == match.away_team_id
      assert match_ratings_1.team_id == match.home_team_id
      assert match_ratings_2.id != match_ratings_1.team_id
    end

    test "create_rating/1 fails with duplicate values" do
      match = InternalDataFixtures.create_match()
      user = AccountsFixtures.users_fixture()

      attrs = %{match_id: match.id, users_id: user.id, team_id: match.home_team_id}
      assert {:ok, _valid_match} = Ratings.create_match_ratings(attrs)

      assert {:error, %Ecto.Changeset{}} = Ratings.create_match_ratings(attrs)
    end

    test "get_ratings_by_user/1 returns only the ratings for the expected user" do
      match = InternalDataFixtures.create_match()
      user1 = AccountsFixtures.users_fixture()
      user2 = AccountsFixtures.users_fixture()

      [
        %{match_id: match.id, users_id: user1.id, team_id: match.home_team_id},
        %{match_id: match.id, users_id: user2.id, team_id: match.home_team_id},
        %{match_id: match.id, users_id: user1.id, team_id: match.away_team_id}
      ]
      |> Enum.map(&Ratings.create_match_ratings/1)

      ratings1 = Ratings.get_ratings_by_user(user1.id)
      assert length(ratings1) == 2
      ratings2 = Ratings.get_ratings_by_user(user2.id)
      assert length(ratings2) == 1
    end

    test "number_of_match_ratings/1 for a given match returns the total ratings by users" do
      match = InternalDataFixtures.create_match()
      user1 = AccountsFixtures.users_fixture()
      user2 = AccountsFixtures.users_fixture()

      [
        %{match_id: match.id, users_id: user1.id, team_id: match.home_team_id},
        %{match_id: match.id, users_id: user2.id, team_id: match.home_team_id},
        %{match_id: match.id, users_id: user1.id, team_id: match.away_team_id}
      ]
      |> Enum.map(&Ratings.create_match_ratings/1)

      assert Ratings.number_of_match_ratings(match.id) == 3
    end
  end

  describe "players_ratings" do
    test "create_player_ratings/1 creates a rating for a player" do
      match_ratings = RatingsFixtures.create_match_ratings()
      player = InternalDataFixtures.create_player(%{team_id: match_ratings.team_id})

      attrs = %{score: 8, player_id: player.id, match_ratings_id: match_ratings.id}
      assert {:ok, player_ratings} = Ratings.create_player_ratings(attrs)
      assert player_ratings.score == attrs[:score]
      assert player_ratings.player_id == attrs[:player_id]
      assert player_ratings.match_ratings_id == attrs[:match_ratings_id]
    end

    test "average_player_ratings/1 returns the average" do
      match = InternalDataFixtures.create_match()
      player = InternalDataFixtures.create_player(%{team_id: match.home_team_id})

      match_ratings =
        for _ <- 1..3,
            do:
              RatingsFixtures.create_match_ratings(%{
                match_id: match.id,
                team_id: match.home_team_id
              })

      scores = [6, 7, 8]

      [scores, match_ratings]
      |> Enum.zip()
      |> Enum.map(fn {score, match_rating} ->
        %{score: score, player_id: player.id, match_ratings_id: match_rating.id}
      end)
      |> Enum.map(&Ratings.create_player_ratings/1)

      averages = Ratings.average_player_ratings(match.id)
      assert averages == %{player.id => 7.0}
    end

    test "create_player_ratings/1 fails if score out of range" do
      match_ratings = RatingsFixtures.create_match_ratings()
      player = InternalDataFixtures.create_player(%{team_id: match_ratings.team_id})

      attrs = %{score: 11, player_id: player.id, match_ratings_id: match_ratings.id}
      assert {:error, %Ecto.Changeset{}} = Ratings.create_player_ratings(attrs)
    end

    test "create_match_and_players_ratings executes successfully in a transaction" do
      match = InternalDataFixtures.create_match()
      user = AccountsFixtures.users_fixture()

      players =
        1..15
        |> Enum.map(&%{id: &1, team_id: match.home_team_id})
        |> Enum.map(&InternalDataFixtures.create_player/1)
        |> Enum.map(fn %FootballInfo.Player{id: id, name: name} -> %{id: id, name: name} end)

      scores =
        players
        |> Enum.map(fn %{id: player_id} ->
          {Integer.to_string(player_id), Integer.to_string(Enum.random(1..10))}
        end)
        |> Map.new()

      assert {:ok, match_ratings_id} =
               Ratings.create_match_and_players_ratings(
                 players,
                 scores,
                 match.home_team_id,
                 match.id,
                 user.id
               )

      results = Ratings.get_players_ratings(match_ratings_id)

      %{team_id: team_id, users_id: users_id, player_ratings: results_players} = results
      assert team_id == match.home_team_id
      assert users_id == user.id
      assert length(results_players) == 15
    end

    test "get_players_ratings/1 returns nil for invalid ratings" do
      assert nil == Ratings.get_players_ratings(System.unique_integer([:positive]))
    end
  end
end
