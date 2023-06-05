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
    {:ok, matches} = FootballApi.matches(league_id, season, yesterday, today)

    matches = FootballApi.Processing.finished_matches(matches)

    # Insert leagues if they don't exist
    matches
    |> FootballApi.Processing.unique_leagues()
    |> Footballratings.FootballInfo.maybe_create_leagues()

    # Insert teams if they don't exist
    teams = FootballApi.Processing.unique_teams(matches)
    Footballratings.FootballInfo.maybe_create_teams(teams)

    matches = FootballApi.Processing.unique_matches(matches)

    matches
    |> Enum.map(&FootballApi.Processing.Match.to_internal_schema/1)
    |> Footballratings.FootballInfo.maybe_create_matches()

    Footballratings.JobCreator.new_jobs_for_teams_squads(teams)
    Footballratings.JobCreator.new_jobs_for_matches_statistics(matches)

    :ok
  end
end
