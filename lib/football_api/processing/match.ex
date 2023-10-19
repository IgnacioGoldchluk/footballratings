defmodule FootballApi.Processing.Match do
  @moduledoc """
  Manages API-fetched Match information, such as filtering and processing
  before inserting into internal repo.
  """

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

  # @in_progress_match_status [
  #   # First half
  #   "1H",
  #   # Halftime
  #   "HT",
  #   # Second half
  #   "2H",
  #   # Extra time
  #   "ET",
  #   # Break time
  #   "BT",
  #   # Penalties
  #   "P",
  #   # Suspended temporarily
  #   "SUSP",
  #   # Postponed
  #   "PST",
  #   # In progress
  #   "LIVE"
  # ]

  # @not_started_match_status [
  #   # Time to be defined
  #   "TBD",
  #   # Not started
  #   "NS",
  #   # Abandoned due to external factors
  #   "ABD"
  # ]
  def finished?(%{"fixture" => %{"status" => %{"short" => status}}}) do
    Enum.member?(@finished_match_status, status)
  end

  def to_internal_schema(%{
        "fixture" => fixture,
        "league" => league,
        "teams" => teams,
        "score" => score
      }) do
    %{"id" => fixture_id, "timestamp" => fixture_timestamp} = fixture
    %{"id" => league_id, "round" => league_round, "season" => league_season} = league
    %{"home" => %{"id" => home_team_id}, "away" => %{"id" => away_team_id}} = teams

    base_schema = %{
      "id" => fixture_id,
      "timestamp" => fixture_timestamp,
      "status" => :not_ready_yet,
      "round" => league_round,
      "league_id" => league_id,
      "home_team_id" => home_team_id,
      "away_team_id" => away_team_id,
      "season" => league_season
    }

    # Need goals_home, goals_away, penalties_home, penalties_away
    score = convert_score(score)

    Map.merge(base_schema, score)
  end

  def extract_league(%{"league" => league}), do: league

  def extract_teams(%{"teams" => %{"home" => ht, "away" => at}}), do: [ht, at]

  # Match went to extra-time
  defp convert_score(%{"extratime" => %{"home" => h, "away" => a}} = score)
       when is_integer(h) and is_integer(a) do
    %{"penalty" => %{"home" => ph, "away" => pa}} = score

    %{
      "goals_home" => h,
      "goals_away" => a,
      "penalties_home" => ph,
      "penalties_away" => pa
    }
  end

  # Match finished in full time
  defp convert_score(%{"fulltime" => %{"home" => h, "away" => a}} = score) do
    %{"penalty" => %{"home" => ph, "away" => pa}} = score

    %{
      "goals_home" => h,
      "goals_away" => a,
      "penalties_home" => ph,
      "penalties_away" => pa
    }
  end
end
