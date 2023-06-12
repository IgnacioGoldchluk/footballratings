defmodule Footballratings.JobCreator do
  @moduledoc """
  Convencience module for creating multiple Oban jobs.
  """
  def new_jobs_for_teams_squads(matches) do
    matches
    |> Enum.map(&teams_squads_args/1)
    |> Enum.map(&Footballratings.Workers.TeamProcessor.new/1)
    |> Oban.insert_all()
  end

  defp teams_squads_args(%{home_team_id: home_team, away_team_id: away_team, id: match_id}) do
    %{home_team_id: home_team, away_team_id: away_team, match_id: match_id}
  end

  def new_job_for_match_statistics(%{"match_id" => match_id}) do
    %{"match_id" => match_id}
    |> Footballratings.Workers.StatisticsProcessor.new()
    |> Oban.insert()
  end
end
