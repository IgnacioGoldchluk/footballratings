defmodule Footballratings.FootballInfo.FootballInfoTest do
  use Footballratings.DataCase

  alias Footballratings.FootballInfo.{Team, Player, Match, PlayerMatch}

  import Footballratings.InternalDataFixtures

  describe "teams" do
    test "create_team/1 creates a team" do
      valid_attrs = %{name: "Team FC", id: System.unique_integer()}

      assert {:ok, %Team{} = team} = Footballratings.FootballInfo.create_team(valid_attrs)
      assert team.name == valid_attrs[:name]
      assert team.id == valid_attrs[:id]
    end

    test "create_team/1 without attributes fails" do
      invalid_attrs = %{}
      assert {:error, %Ecto.Changeset{}} = Footballratings.FootballInfo.create_team(invalid_attrs)
    end

    test "matches_available_for_rating_for_team/1 returns only where team id matches" do
      match1 = create_match()
      _match2 = create_match()

      existing_team = match1.home_team_id

      matches = Footballratings.FootballInfo.matches_available_for_rating_for_team(existing_team)
      assert length(matches) == 1
      [%{id: match_id}] = matches
      assert match_id == match1.id

      non_existing_team_id = System.unique_integer([:positive])

      matches =
        Footballratings.FootballInfo.matches_available_for_rating_for_team(non_existing_team_id)

      assert length(matches) == 0
    end
  end

  describe "players" do
    test "create_player/1 with valid params creates a player" do
      team = create_team()

      player_attrs = %{
        name: "M Kovacic",
        age: 30,
        id: System.unique_integer([:positive]),
        team_id: team.id
      }

      {:ok, player} = Footballratings.FootballInfo.create_player(player_attrs)

      assert player.name == player_attrs[:name]
      assert player.age == player_attrs[:age]
      assert player.id == player_attrs[:id]
      assert player.team_id == player_attrs.team_id

      # He switched to Manchester City
      team = create_team(%{name: "Manchester City FC"})
      player_attrs = %{player_attrs | team_id: team.id}

      Footballratings.FootballInfo.maybe_create_players([player_attrs])

      player = Repo.get(Player, player_attrs[:id]) |> Repo.preload(:team)

      assert player.team.name == "Manchester City FC"
    end
  end

  describe "matches" do
    test "create_match/1 with valid attrs creates a match" do
      home_team = create_team()
      away_team = create_team()
      league = create_league()

      match_attrs = %{
        season: 2023,
        timestamp: System.unique_integer([:positive]),
        round: "1 of 38",
        goals_home: 1,
        goals_away: 2,
        penalties_home: nil,
        penalties_away: nil,
        league_id: league.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        status: :ready,
        id: System.unique_integer([:positive])
      }

      {:ok, %Match{} = match} = Footballratings.FootballInfo.create_match(match_attrs)

      assert match.season == match_attrs[:season]
      assert match.timestamp == match_attrs[:timestamp]
      assert match.round == match_attrs[:round]
      assert match.goals_home == match_attrs[:goals_home]
      assert match.goals_away == match_attrs[:goals_away]
      assert match.penalties_home == match_attrs[:penalties_home]
      assert match.penalties_away == match_attrs[:penalties_away]
      assert match.home_team_id == match_attrs[:home_team_id]
      assert match.away_team_id == match_attrs[:away_team_id]
      assert match.status == match_attrs[:status]
      assert match.id == match_attrs[:id]
    end

    test "create_match/1 with null goals returns error" do
      league = create_league()
      home = create_team()
      away = create_team()

      match_attrs = %{
        season: 2023,
        timestamp: System.unique_integer([:positive]),
        round: "1 of 38",
        goals_home: nil,
        goals_away: nil,
        penalties_home: nil,
        penalties_away: nil,
        league_id: league.id,
        home_team_id: home.id,
        away_team_id: away.id,
        status: :ready,
        id: System.unique_integer([:positive])
      }

      assert {:error, %Ecto.Changeset{}} = Footballratings.FootballInfo.create_match(match_attrs)
    end

    test "match_exists? correctly returns whether a match exists" do
      match = create_match()

      assert Footballratings.FootballInfo.match_exists?(match.id)
      assert not Footballratings.FootballInfo.match_exists?(System.unique_integer([:positive]))
    end

    test "set match as ready updates the match" do
      match = create_match(status: :not_ready_yet)

      assert match.status == :not_ready_yet

      assert {:ok, updated_match} =
               Footballratings.FootballInfo.set_match_status_to_ready(match.id)

      assert updated_match.status == :ready
    end

    test "create_matches inserts multiple matches at once" do
      home_team = create_team()
      away_team = create_team()
      league = create_league()

      match1 = %{
        season: 2023,
        timestamp: System.unique_integer([:positive]),
        round: "1 of 38",
        goals_home: 1,
        goals_away: 2,
        penalties_home: nil,
        penalties_away: nil,
        league_id: league.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        status: :ready,
        id: System.unique_integer([:positive])
      }

      # Yeah I'm being lazy here
      match2 = %{match1 | id: System.unique_integer([:positive])}

      [match1, match2] |> Footballratings.FootballInfo.create_matches()
      assert Repo.get(Match, match1.id)
      assert Repo.get(Match, match2.id)
    end

    test "matches_available_for_rating returns the expected_matches" do
      now = DateTime.utc_now() |> DateTime.to_unix()
      yesterday = now - 24 * 60 * 60

      matches =
        [
          # 2 matches that we should get back
          %{status: :ready, timestamp: yesterday},
          %{status: :ready, timestamp: now},
          # 2 matches that we should not get back
          %{status: :expired},
          %{status: :not_ready_yet}
        ]
        |> Enum.map(&create_match/1)

      [yesterday_match, today_match | _rest] = matches

      results = Footballratings.FootballInfo.matches_available_for_rating()
      [first_match, second_match] = results
      assert today_match.id == first_match.id
      assert yesterday_match.id == second_match.id
    end

    test "get_match_with_team_and_league/1 returns the expected format" do
      match = create_match()

      match_with_team_and_league =
        Footballratings.FootballInfo.get_match_with_team_and_league(match.id)

      queried_match = match_with_team_and_league
      assert queried_match.id == match.id

      %{home_team: %{id: ht_id}, away_team: %{id: at_id}} = match_with_team_and_league
      assert ht_id == match.home_team_id
      assert at_id == match.away_team_id
    end
  end

  describe "players_matches" do
    test "create_player_match/1 with valid attrs creates a player_match" do
      match = create_match()
      player = create_player(%{team_id: match.home_team_id})

      attrs = %{
        match_id: match.id,
        player_id: player.id,
        team_id: match.home_team_id,
        minutes_played: 90
      }

      {:ok, %PlayerMatch{} = player_match} =
        Footballratings.FootballInfo.create_player_match(attrs)

      assert player_match.match_id == attrs[:match_id]
      assert player_match.player_id == attrs[:player_id]
      assert player_match.team_id == attrs[:team_id]
      assert player_match.minutes_played == attrs[:minutes_played]
    end

    test "create_player_match creates multiple players" do
      match = create_match()
      players = for _ <- 1..11, do: create_player(team_id: match.home_team_id)

      players
      |> Enum.map(fn player ->
        %{
          match_id: match.id,
          player_id: player.id,
          minutes_played: :rand.uniform(90) + 1,
          team_id: player.team_id
        }
      end)
      |> Footballratings.FootballInfo.create_players_matches()

      total = PlayerMatch |> Ecto.Query.where(match_id: ^match.id) |> Repo.all()

      assert length(total) == 11
    end

    test "players_for_match/1 and /2 returns the players for a given match" do
      match = create_match()
      home_players = for _ <- 1..12, do: create_player(%{team_id: match.home_team_id})
      away_players = for _ <- 1..14, do: create_player(%{team_id: match.away_team_id})

      home_players
      |> Enum.concat(away_players)
      |> Enum.map(fn player ->
        %{
          match_id: match.id,
          player_id: player.id,
          minutes_played: :rand.uniform(89) + 1,
          team_id: player.team_id
        }
      end)
      |> Footballratings.FootballInfo.create_players_matches()

      total_home = Footballratings.FootballInfo.players_for_match(match.id, match.home_team_id)
      assert length(total_home) == 12
      total_away = Footballratings.FootballInfo.players_for_match(match.id, match.away_team_id)
      assert length(total_away) == 14

      %{players_matches: total} = Footballratings.FootballInfo.players_for_match(match.id)
      assert length(total) == 26
    end
  end

  describe "coaches" do
    test "create_coach with valid parameters inserts a new coach" do
      team = create_team()

      attrs = %{
        name: "Guardiola",
        age: 50,
        id: System.unique_integer([:positive]),
        team_id: team.id
      }

      {:ok, coach} = Footballratings.FootballInfo.create_coach(attrs)

      assert coach.name == attrs[:name]
      assert coach.age == attrs[:age]
      assert coach.firstname == nil
      assert coach.lastname == nil
      assert coach.team_id == attrs[:team_id]
    end
  end

  describe "coaches_matches" do
    test "create_coach_match with valid attrs creates a coach match" do
      coach = create_coach()
      match = create_match()

      attrs = %{match_id: match.id, coach_id: coach.id, team_id: coach.team_id}

      {:ok, coach_match} = Footballratings.FootballInfo.create_coach_match(attrs)

      assert coach_match.match_id == attrs[:match_id]
      assert coach_match.coach_id == attrs[:coach_id]
      assert coach_match.team_id == attrs[:team_id]
    end
  end
end
