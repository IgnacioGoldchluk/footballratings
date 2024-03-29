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

      attrs = %{match_id: match.id, users_id: user.id, team_id: match.home_team_id}
      assert {:ok, match_rating} = Ratings.create_match_ratings(attrs)
      assert match_rating.match_id == attrs[:match_id]
      assert match_rating.users_id == attrs[:users_id]
      assert match_rating.team_id == attrs[:team_id]
    end

    test "get_match_ratings_id/3 return the id when exists, nil otherwise" do
      match = InternalDataFixtures.create_match()
      user = AccountsFixtures.users_fixture()

      attrs = %{match_id: match.id, users_id: user.id, team_id: match.home_team_id}
      assert {:ok, match_rating} = Ratings.create_match_ratings(attrs)

      team_id = match.home_team_id

      assert nil == Ratings.match_ratings_id(match.id, team_id, System.unique_integer())

      assert match_rating.id == Ratings.match_ratings_id(match.id, match.home_team_id, user.id)
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

    test "total_match_ratings/0 returns the number of match ratings" do
      assert 0 == Ratings.total_match_ratings()
      RatingsFixtures.create_match_ratings()
      assert 1 == Ratings.total_match_ratings()
    end

    test "count_match_ratings_for_team/1 returns the number of match ratings for a given team" do
      match_ratings = RatingsFixtures.create_match_ratings()

      assert 0 == Ratings.count_match_ratings_for_team(System.unique_integer([:positive]))
      assert 1 == Ratings.count_match_ratings_for_team(match_ratings.team_id)

      RatingsFixtures.create_match_ratings(%{team_id: match_ratings.team_id})
      assert 2 == Ratings.count_match_ratings_for_team(match_ratings.team_id)
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

      scores =
        players
        |> Enum.map(fn %{id: player_id} ->
          {Integer.to_string(player_id), Integer.to_string(Enum.random(1..10))}
        end)
        |> Map.new()

      assert {:ok, %{id: match_ratings_id}} =
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

    test "player_statistics/1 and player_statistics/2 returns the average for a player grouped by match" do
      # Will need date to consistently sort results
      now = DateTime.utc_now() |> DateTime.to_unix()
      team1 = InternalDataFixtures.create_team(%{name: "One FC"})
      team2 = InternalDataFixtures.create_team(%{name: "Two FC"})
      player = InternalDataFixtures.create_player(%{team_id: team1.id})
      player_id_score = player.id |> Integer.to_string()

      match = InternalDataFixtures.create_match(%{home_team_id: team1.id, timestamp: now})

      # Create 2 scores for a single match.
      scores = [%{player_id_score => "4"}, %{player_id_score => "6"}]

      scores
      |> Enum.each(fn score ->
        user = AccountsFixtures.users_fixture()

        assert {:ok, _match_ratings} =
                 Ratings.create_match_and_players_ratings(
                   [player],
                   score,
                   match.home_team_id,
                   match.id,
                   user.id
                 )
      end)

      a_week_ago = now - 24 * 60 * 60
      # Pretend player switched team and do everything again.
      match2 = InternalDataFixtures.create_match(%{away_team_id: team2.id, timestamp: a_week_ago})
      scores = [%{player_id_score => "8"}, %{player_id_score => "7"}]

      scores
      |> Enum.each(fn score ->
        user = AccountsFixtures.users_fixture()

        assert {:ok, _match_ratings} =
                 Ratings.create_match_and_players_ratings(
                   [player],
                   score,
                   match2.away_team_id,
                   match2.id,
                   user.id
                 )
      end)

      assert [first, second] = Ratings.player_statistics(player.id)

      assert first[:average] == 7.5
      assert first[:timestamp] == match2.timestamp
      assert first[:team] == team2.name

      assert second[:average] == 5.0
      assert second[:timestamp] == match.timestamp
      assert second[:team] == team1.name

      # Now obtain the results but for the first team only
      assert [first] = Ratings.player_statistics(player.id, team1.name)
      assert first[:average] == 5.0
      assert first[:timestamp] == match.timestamp
      assert first[:team] == team1.name
    end
  end

  describe "count_ratings_by_user/2" do
    test "returns the number of ratings for the given user" do
      match = InternalDataFixtures.create_match()
      user1 = AccountsFixtures.users_fixture()
      user2 = AccountsFixtures.users_fixture()

      attrs = %{match_id: match.id, users_id: user1.id, team_id: match.home_team_id}
      assert {:ok, _} = Ratings.create_match_ratings(attrs)

      a_week_ago = DateTime.utc_now() |> DateTime.add(-7, :day)
      tomorrow = DateTime.utc_now() |> DateTime.add(1, :day)
      assert 0 == Ratings.count_ratings_by_user(user2.id, a_week_ago)
      assert 0 == Ratings.count_ratings_by_user(user1.id, tomorrow)
      assert 1 == Ratings.count_ratings_by_user(user1.id, a_week_ago)
    end
  end
end
