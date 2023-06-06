defmodule Footballratings.ExternalMatchesFixtures do
  alias FootballApi.Models.Matches.{
    Score,
    TemporalScore,
    Match,
    League,
    Fixture,
    Teams,
    Status,
    Team
  }

  @letters 'abcdefghijklmnoprqstuvwxyz'

  defp random_string() do
    for _ <- 1..10, into: "", do: <<Enum.random(@letters)>>
  end

  def create_league(id \\ :rand.uniform(200)) do
    %League{
      id: id,
      season: :rand.uniform(10) + 2000,
      round: "Round #{:rand.uniform(37) + 1} of 38",
      name: "#{random_string()} League"
    }
  end

  def create_status(status \\ "FT") do
    %Status{short: status}
  end

  def create_team(id \\ :rand.uniform(200)) do
    %Team{
      id: id,
      name: "#{random_string()} F.C."
    }
  end

  defp nil_score_attrs() do
    %TemporalScore{home: nil, away: nil}
  end

  defp valid_score_attrs() do
    %TemporalScore{home: :rand.uniform(7), away: :rand.uniform(7)}
  end

  def create_score() do
    %Score{
      extratime: nil_score_attrs(),
      penalty: nil_score_attrs(),
      fulltime: valid_score_attrs(),
      halftime: %TemporalScore{home: 0, away: 0}
    }
  end

  def valid_penalties_score_attrs() do
    %Score{
      extratime: %TemporalScore{home: 2, away: 2},
      halftime: %TemporalScore{home: 0, away: 1},
      fulltime: %TemporalScore{home: 1, away: 1},
      penalty: %TemporalScore{home: 5, away: 4}
    }
  end

  def create_match() do
    %Match{
      fixture: create_fixture(),
      score: create_score(),
      teams: create_teams(),
      league: create_league()
    }
  end

  def create_teams() do
    # Make sure both teams are different
    team1_id = :rand.uniform(200)
    team2_id = team1_id + 10

    %Teams{
      home: create_team(team1_id),
      away: create_team(team2_id)
    }
  end

  def create_fixture(id \\ :rand.uniform(200)) do
    %Fixture{
      status: create_status(),
      id: id,
      timestamp: 1_686_024_322 + :rand.uniform(10000)
    }
  end

  def insert_league(%Match{} = match, %League{} = league) do
    %Match{match | league: league}
  end

  def insert_home_team(%Match{teams: teams} = match, %Team{} = home_team) do
    teams = %Teams{teams | home: home_team}
    %Match{match | teams: teams}
  end

  def insert_away_team(%Match{teams: teams} = match, %Team{} = away_team) do
    teams = %Teams{teams | away: away_team}
    %Match{match | teams: teams}
  end

  def insert_match_status(%Match{} = match, %Status{} = new_status) do
    %{fixture: fixture} = match
    new_fixure = %Fixture{fixture | status: new_status}
    %Match{match | fixture: new_fixure}
  end
end
