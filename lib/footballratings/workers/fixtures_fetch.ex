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
  def perform(%Oban.Job{args: %{"league" => league_id, "season" => season}}) do
    new_finished_matches = fetch_new_finished_matches(league_id, season)

    {:ok, _leagues} = maybe_create_leagues(new_finished_matches)
    {:ok, _teams} = maybe_create_teams(new_finished_matches)

    new_finished_matches_schemas = FootballApi.Processing.unique_matches(new_finished_matches)
    Footballratings.FootballInfo.create_matches(new_finished_matches_schemas)

    Footballratings.JobCreator.new_jobs_for_teams_squads(new_finished_matches_schemas)
    :ok
  end

  defp fetch_new_finished_matches(league_id, season) do
    today = Date.utc_today()
    yesterday = Date.add(today, -1)
    {:ok, matches} = FootballApi.matches(league_id, season, yesterday, today)

    matches
    |> Enum.filter(fn %{"fixture" => %{"id" => match_id}} = match ->
      FootballApi.Processing.match_finished?(match) and
        not Footballratings.FootballInfo.match_exists?(match_id)
    end)
  end

  defp maybe_create_leagues(new_finished_matches) do
    # Insert leagues if they don't exist
    leagues = FootballApi.Processing.unique_leagues(new_finished_matches)
    Footballratings.FootballInfo.maybe_create_leagues(leagues)

    {:ok, leagues}
  end

  defp maybe_create_teams(new_finished_matches) do
    # Insert teams if they don't exist
    teams = FootballApi.Processing.unique_teams(new_finished_matches)
    Footballratings.FootballInfo.maybe_create_teams(teams)

    {:ok, teams}
  end
end
