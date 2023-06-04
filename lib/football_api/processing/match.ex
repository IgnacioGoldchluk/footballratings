defmodule FootballApi.Processing.Match do
  alias FootballApi.Models.Matches.{Match, Score}

  @finished_match_status [
    # Finished
    "FT",
    # Finished after extra time
    "AET",
    # Finished after penalties
    "PEN",
    # Technical loss
    "AWD",
    # WalkOver
    "WO"
  ]

  @in_progress_match_status [
    # First half
    "1H",
    # Halftime
    "HT",
    # Second half
    "2H",
    # Extra time
    "ET",
    # Break time
    "BT",
    # Penalties
    "P",
    # Suspended temporarily
    "SUSP",
    # Postponed
    "PST",
    # In progress
    "LIVE"
  ]

  @not_started_match_status [
    # Time to be defined
    "TBD",
    # Not started
    "NS",
    # Abandoned due to external factors
    "ABD"
  ]

  @match_status @in_progress_match_status ++ @not_started_match_status ++ @finished_match_status

  def match_finished?(%Match{} = match) do
    status_finished?(match.fixture.status.short)
  end

  defp status_finished?(match_status), do: Enum.member?(@finished_match_status, match_status)

  def to_internal_match_schema(%Match{fixture: fixture, league: league, teams: teams} = match) do
    base_schema = %{
      "id" => fixture.id,
      "timestamp" => fixture.timestamp,
      "status" => "not_ready_yet",
      "round" => league.round,
      "league_id" => league.id,
      "home_team_id" => teams.home.id,
      "away_team_id" => teams.away.id,
      "season" => league.season
    }

    # Need goals_home, goals_away, penalties_home, penalties_away
    score = convert_score(match.score)

    Map.merge(base_schema, score)
  end

  def extract_league(%Match{league: league}), do: league

  def extract_teams(%Match{teams: %{home: home_team, away: away_team}}) do
    [home_team, away_team]
  end

  # Match went to extra-time
  defp convert_score(%Score{extratime: %{home: home, away: away}} = score)
       when is_integer(home) and is_integer(away) do
    %{
      "goals_home" => home,
      "goals_away" => away,
      "penalties_home" => score.penalty.home,
      "penalties_away" => score.penalty.away
    }
  end

  # Match finished in full time
  defp convert_score(%Score{fulltime: %{home: home, away: away}} = score) do
    %{
      "goals_home" => home,
      "goals_away" => away,
      "penalties_home" => score.penalty.home,
      "penalties_away" => score.penalty.away
    }
  end
end
