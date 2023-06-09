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
  end

  describe "players_matches" do
    test "create_player_match/1 with valid attrs creates a player_match" do
      league = create_league()
      home_team = create_team()
      away_team = create_team()

      match =
        create_match(%{
          league_id: league.id,
          home_team_id: home_team.id,
          away_team_id: away_team.id
        })

      player = create_player(%{team_id: home_team.id})

      attrs = %{
        match_id: match.id,
        player_id: player.id,
        team_id: home_team.id,
        minutes_played: 90
      }

      {:ok, %PlayerMatch{} = player_match} =
        Footballratings.FootballInfo.create_player_match(attrs)

      assert player_match.match_id == attrs[:match_id]
      assert player_match.player_id == attrs[:player_id]
      assert player_match.team_id == attrs[:team_id]
      assert player_match.minutes_played == attrs[:minutes_played]
    end
  end
end
