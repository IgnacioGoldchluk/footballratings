defmodule Footballratings.Workers.FixturesFetch do
  @moduledoc """
  Fetches information for a given league and season.

  This worker should be called as a cron job and performs the following
  1. Fetches all the matches.
  2. Inserts any league that hasn't been seen before.
  3. Inserts any team that hasn't been seen before.
  4. Keep matches that have finished.
  5. Trigger jobs to fill with players statistics.
  """
  use Oban.Worker, queue: :default

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => league_id, "season" => season}}) do
    today = Date.utc_today()
    yesterday = Date.add(today, -1)
    {:ok, response} = FootballApi.matches(league_id, season, yesterday, today)

    # FIXME: Filter only for matches that have finished.

    # Insert leagues if they don't exist
    response
    |> Enum.map(&FootballApi.Processing.Match.extract_league/1)
    |> Enum.map(&FootballApi.Processing.League.to_internal_league_schema/1)
    |> Enum.uniq_by(&Map.get(&1, "id"))
    |> Footballratings.FootballInfo.maybe_create_leagues()

    # Insert teams if they don't exist
    teams =
      response
      |> Enum.flat_map(&FootballApi.Processing.Match.extract_teams/1)
      |> Enum.map(&FootballApi.Processing.Team.to_internal_team_schema/1)
      |> Enum.uniq_by(&Map.get(&1, "id"))

    Footballratings.FootballInfo.maybe_create_teams(teams)

    # Create jobs to fetch and insert all teams squads
    teams
    |> Enum.map(&%{team_id: Map.get(&1, "id")})
    |> Enum.map(&Footballratings.Workers.TeamProcessor.new/1)
    |> Oban.insert_all()

    # Create all matches
    matches =
      response
      |> Enum.map(&FootballApi.Processing.Match.to_internal_match_schema/1)

    Footballratings.FootballInfo.maybe_create_matches(matches)

    # Create jobs to fetch and insert all matches statistics
    matches
    |> Enum.map(&%{match_id: Map.get(&1, "id")})
    |> Enum.map(&Footballratings.Workers.StatisticsProcessor.new/1)
    |> Oban.insert_all()

    :ok
  end
end
