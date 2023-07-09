defmodule Footballratings.FootballInfo.FootballInfoTest do
  use Footballratings.DataCase

  alias Footballratings.FootballInfo.{Team, Player, Match, PlayerMatch}
  alias Footballratings.FootballInfo

  import Footballratings.InternalDataFixtures

  describe "teams" do
    test "create_team/1 creates a team" do
      valid_attrs = %{name: "Team FC", id: System.unique_integer()}

      assert {:ok, %Team{} = team} = FootballInfo.create_team(valid_attrs)
      assert team.name == valid_attrs[:name]
      assert team.id == valid_attrs[:id]
    end

    test "create_team/1 without attributes fails" do
      invalid_attrs = %{}
      assert {:error, %Ecto.Changeset{}} = FootballInfo.create_team(invalid_attrs)
    end

    test "get_team/1 returns the team for the given id" do
      team = create_team()

      assert team == FootballInfo.get_team(team.id)
      assert nil == FootballInfo.get_team(System.unique_integer([:positive]))
    end

    test "matches_available_for_rating_for_team/1 returns only where team id matches" do
      match1 = create_match()
      _match2 = create_match()

      existing_team = match1.home_team_id

      matches = FootballInfo.matches_available_for_rating_for_team(existing_team)
      assert length(matches) == 1
      [%{id: match_id}] = matches
      assert match_id == match1.id

      non_existing_team_id = System.unique_integer([:positive])

      matches = FootballInfo.matches_available_for_rating_for_team(non_existing_team_id)

      assert length(matches) == 0
    end

    test "teams_a_player_has_played_for/1 returns unique teams" do
      match1 = create_match()
      match2 = create_match()
      match3 = create_match(%{home_team_id: match2.home_team_id})
      player = create_player(team_id: match2.away_team_id)

      team1_id = player.team_id
      team2_id = match1.home_team_id
      team3_id = match1.home_team_id

      create_player_match(%{player_id: player.id, team_id: team1_id, match_id: match1.id})
      create_player_match(%{player_id: player.id, team_id: team2_id, match_id: match2.id})
      create_player_match(%{player_id: player.id, team_id: team3_id, match_id: match3.id})

      assert %{teams: teams} = FootballInfo.teams_a_player_has_played_for(player.id)

      teams_ids = teams |> Enum.map(&Map.get(&1, :id)) |> MapSet.new()

      assert teams_ids == MapSet.new([team1_id, team2_id, team3_id])
    end

    test "team_with_players/1 returns the current players by the team id" do
      team = create_team(%{name: "Test Team FC"})
      other_team = create_team()

      player = create_player(%{team_id: team.id})
      create_player(%{team_id: other_team.id})

      result = FootballInfo.team_with_players(team.id)

      assert result.name == team.name
      assert result.id == team.id

      result_players = result.players

      assert length(result_players) == 1
      [result_player] = result_players
      assert result_player.id == player.id
    end
  end

  describe "players" do
    test "create_player/1 with valid params creates a player" do
      team = create_team()

      player_attrs = %{
        name: "M. Kovačić",
        age: 30,
        id: System.unique_integer([:positive]),
        team_id: team.id
      }

      {:ok, player} = FootballInfo.create_player(player_attrs)

      assert player.name == "M. Kovacic"
      assert player.age == player_attrs[:age]
      assert player.id == player_attrs[:id]
      assert player.team_id == player_attrs.team_id

      # He switched to Manchester City
      team = create_team(%{name: "Manchester City FC"})
      player_attrs = %{player_attrs | team_id: team.id}

      FootballInfo.maybe_create_players([player_attrs])

      player = Repo.get(Player, player_attrs[:id]) |> Repo.preload(:team)

      assert player.team.name == "Manchester City FC"
    end

    test "get_player/1 returns the player by id" do
      team = create_team()
      player = create_player(%{team_id: team.id})

      result = FootballInfo.get_player(player.id)

      assert player == result
    end

    test "player_exists?/1 returns whether the player exists or not" do
      team = create_team()
      player = create_player(%{team_id: team.id})

      refute FootballInfo.player_exists?(System.unique_integer([:positive]))
      assert FootballInfo.player_exists?(player.id)
    end
  end

  describe "leagues" do
    test "get_all_leagues/1 returns all the leagues" do
      assert [] = FootballInfo.get_all_leagues()

      league = create_league()

      assert [result] = FootballInfo.get_all_leagues()
      assert result.id == league.id
      assert result.name == league.name
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

      {:ok, %Match{} = match} = FootballInfo.create_match(match_attrs)

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

      assert {:error, %Ecto.Changeset{}} = FootballInfo.create_match(match_attrs)
    end

    test "match_exists? correctly returns whether a match exists" do
      match = create_match()

      assert FootballInfo.match_exists?(match.id)
      assert not FootballInfo.match_exists?(System.unique_integer([:positive]))
    end

    test "set match as ready updates the match" do
      match = create_match(status: :not_ready_yet)

      assert match.status == :not_ready_yet

      assert {:ok, updated_match} = FootballInfo.set_match_status_to_ready(match.id)

      assert updated_match.status == :ready
    end

    test "get_match/1 returns match by id" do
      match = create_match()

      assert match == FootballInfo.get_match(match.id)
      assert nil == FootballInfo.get_match(System.unique_integer([:positive]))
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

      [match1, match2] |> FootballInfo.create_matches()
      assert Repo.get(Match, match1.id)
      assert Repo.get(Match, match2.id)
    end

    test "matches_for_player/1 returns the matches where player took part of" do
      team = create_team()
      player = create_player(%{team_id: team.id})
      match = create_match(%{home_team_id: team.id})
      _other_match = create_match()

      _player_match =
        create_player_match(%{match_id: match.id, player_id: player.id, team_id: team.id})

      assert [result] = FootballInfo.matches_for_player(player.id)
      assert result.id == match.id

      other_player = create_player(%{team_id: team.id})
      assert [] = FootballInfo.matches_for_player(other_player.id)
    end

    test "matches_for_team/1 returns matches where either home or away team are present" do
      team = create_team()
      match1 = create_match(%{home_team_id: team.id})
      match2 = create_match(%{away_team_id: team.id})
      match3 = create_match()

      assert [m1, m2] = FootballInfo.matches_for_team(team.id)
      ids = for m <- [m1, m2], do: m.id, into: MapSet.new()

      assert match1.id in ids
      assert match2.id in ids
      refute match3.id in ids
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

      results = FootballInfo.matches_available_for_rating()
      [first_match, second_match] = results
      assert today_match.id == first_match.id
      assert yesterday_match.id == second_match.id
    end

    test "get_match_with_team_and_league/1 returns the expected format" do
      match = create_match()

      match_with_team_and_league = FootballInfo.get_match_with_team_and_league(match.id)

      queried_match = match_with_team_and_league
      assert queried_match.id == match.id

      %{home_team: %{id: ht_id}, away_team: %{id: at_id}} = match_with_team_and_league
      assert ht_id == match.home_team_id
      assert at_id == match.away_team_id
    end

    test "total_matches/1 returns the number of matches" do
      assert 0 == FootballInfo.total_matches()
      create_match()
      assert 1 == FootballInfo.total_matches()
    end

    test "count_matches_for_team/1 returns the total unique matches by the team id" do
      match = create_match()
      team_id = match.home_team_id

      assert 1 == FootballInfo.count_matches_for_team(team_id)
      assert 0 == FootballInfo.count_matches_for_team(System.unique_integer([:positive]))
      assert 1 == FootballInfo.count_matches_for_team(match.away_team_id)

      create_match(%{home_team_id: team_id})

      assert 2 == FootballInfo.count_matches_for_team(team_id)
    end
  end

  describe "players_for_search_params/1" do
    setup do
      [base_query: %{"name" => ""}]
    end

    test "filters by player name", %{base_query: base_query} do
      team = create_team()
      player1 = create_player(%{name: "Courtois", team_id: team.id})
      player2 = create_player(%{name: "Toimono", team_id: team.id})

      search_params = base_query |> Map.put("name", "A name that does not exist")
      assert [] = FootballInfo.players_for_search_params(search_params)

      search_params = base_query |> Map.put("name", "RTOiS")
      assert [result] = FootballInfo.players_for_search_params(search_params)
      assert result.name == player1.name
      assert result.id == player1.id

      search_params = base_query |> Map.put("name", "toi")
      assert [p1, p2] = FootballInfo.players_for_search_params(search_params)
      assert p1.id == player1.id
      assert p1.name == player1.name
      assert p2.id == player2.id
      assert p2.name == player2.name

      search_params = base_query
      assert [p1, p2] = FootballInfo.players_for_search_params(search_params)
      assert p1.id == player1.id
      assert p1.name == player1.name
      assert p2.id == player2.id
      assert p2.name == player2.name
    end
  end

  describe "teams_for_search_params/1" do
    setup do
      [base_query: %{"name" => ""}]
    end

    test "filters by team name", %{base_query: base_query} do
      team = create_team(%{name: "FC Team warriors"})
      team2 = create_team(%{name: "FC War"})
      team3 = create_team(%{name: "WA River"})

      search_params = base_query |> Map.put("name", "war")

      result = FootballInfo.teams_for_search_params(search_params)

      assert length(result) == 2
      ids = for team <- result, do: team.id, into: MapSet.new()

      assert team.id in ids
      assert team2.id in ids
      assert team3.id not in ids

      search_params = base_query
      result = FootballInfo.teams_for_search_params(search_params)

      assert length(result) == 3
      ids = for team <- result, do: team.id, into: MapSet.new()

      assert team.id in ids
      assert team2.id in ids
      assert team3.id in ids
    end
  end

  describe "matches_for_search_params/1" do
    setup do
      [
        base_query: %{
          "before" => "",
          "after" => "",
          "home_team" => "",
          "away_team" => "",
          "league" => "",
          "available_for_rating" => ""
        }
      ]
    end

    test "filters by the teams names", %{base_query: base_query} do
      home_team = create_team(%{name: "Green Team"})
      away_team = create_team(%{name: "Black Team"})

      match1 = create_match(%{home_team_id: home_team.id, away_team_id: away_team.id})
      match2 = create_match(%{home_team_id: away_team.id, away_team_id: home_team.id})

      search_params = base_query |> Map.put("home_team", away_team.name)

      assert [result] = FootballInfo.matches_for_search_params(search_params)
      assert result.id == match2.id

      search_params = base_query |> Map.put("away_team", "lack")
      assert [result] = FootballInfo.matches_for_search_params(search_params)
      assert result.id == match1.id
    end

    test "filters by availability", %{base_query: base_query} do
      match1 = create_match(%{status: :ready})

      match2 = create_match(%{status: :expired})

      search_params = base_query |> Map.put("available_for_rating", "true")

      assert [result] = FootballInfo.matches_for_search_params(search_params)
      assert result.id == match1.id

      search_params = search_params |> Map.put("available_for_rating", "false")
      assert result = FootballInfo.matches_for_search_params(search_params)

      assert length(result) == 2
      matches_ids = Enum.map(result, & &1.id) |> Enum.uniq()
      assert match1.id in matches_ids
      assert match2.id in matches_ids
    end

    test "filters by date", %{base_query: base_query} do
      match = create_match()

      tomorrow =
        DateTime.utc_now() |> DateTime.add(1, :day) |> DateTime.to_date() |> Date.to_string()

      search_params = base_query |> Map.put("after", tomorrow)
      assert [] = FootballInfo.matches_for_search_params(search_params)

      search_params = base_query |> Map.put("before", tomorrow)
      assert [m] = FootballInfo.matches_for_search_params(search_params)
      assert m.id == match.id

      yesterday =
        DateTime.utc_now() |> DateTime.add(-1, :day) |> DateTime.to_date() |> Date.to_string()

      search_params = base_query |> Map.put("after", yesterday)
      assert [m] = FootballInfo.matches_for_search_params(search_params)
      assert m.id == match.id

      search_params = base_query |> Map.put("before", yesterday)
      assert [] = FootballInfo.matches_for_search_params(search_params)
    end

    test "filters by league", %{base_query: base_query} do
      league_1 = create_league(%{name: "Ligue 1"})
      league_2 = create_league(%{name: "Ligue 2"})

      match_1 = create_match(%{league_id: league_1.id})
      _match_2 = create_match(%{league_id: league_2.id})

      search_params = base_query |> Map.put("league", league_1.name)

      assert [result] = FootballInfo.matches_for_search_params(search_params)
      assert result.id == match_1.id

      search_params = base_query |> Map.put("league", "ASD")
      assert [] = FootballInfo.matches_for_search_params(search_params)
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

      {:ok, %PlayerMatch{} = player_match} = FootballInfo.create_player_match(attrs)

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
      |> FootballInfo.create_players_matches()

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
      |> FootballInfo.create_players_matches()

      total_home = FootballInfo.players_for_match(match.id, match.home_team_id)
      assert length(total_home) == 12
      total_away = FootballInfo.players_for_match(match.id, match.away_team_id)
      assert length(total_away) == 14

      %{players_matches: total} = FootballInfo.players_for_match(match.id)
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

      {:ok, coach} = FootballInfo.create_coach(attrs)

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

      {:ok, coach_match} = FootballInfo.create_coach_match(attrs)

      assert coach_match.match_id == attrs[:match_id]
      assert coach_match.coach_id == attrs[:coach_id]
      assert coach_match.team_id == attrs[:team_id]
    end
  end
end
