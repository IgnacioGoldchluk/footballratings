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

    new_finished_matches =
      matches
      |> Enum.filter(&FootballApi.Processing.match_finished?/1)
      |> Enum.filter(fn %{fixture: %{id: match_id}} ->
        not Footballratings.FootballInfo.match_exists?(match_id)
      end)

    # Insert leagues if they don't exist
    leagues = FootballApi.Processing.unique_leagues(new_finished_matches)
    Footballratings.FootballInfo.maybe_create_leagues(leagues)

    # Insert teams if they don't exist
    teams = FootballApi.Processing.unique_teams(new_finished_matches)
    Footballratings.FootballInfo.maybe_create_teams(teams)

    new_finished_matches_schemas = FootballApi.Processing.unique_matches(new_finished_matches)
    Footballratings.FootballInfo.create_matches(new_finished_matches_schemas)

    Footballratings.JobCreator.new_jobs_for_teams_squads(teams)
    Footballratings.JobCreator.new_jobs_for_matches_statistics(new_finished_matches_schemas)

    :ok
  end
end
