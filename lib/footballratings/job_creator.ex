defmodule Footballratings.JobCreator do
  def new_jobs_for_teams_squads(teams) do
    teams
    |> Enum.map(&%{team_id: Map.get(&1, "id")})
    |> Enum.map(&Footballratings.Workers.TeamProcessor.new/1)
    |> Oban.insert_all()
  end

  def new_jobs_for_matches_statistics(matches) do
    matches
    |> Enum.map(&%{match_id: Map.get(&1, "id")})
    |> Enum.map(&Footballratings.Workers.StatisticsProcessor.new/1)
    |> Oban.insert_all()
  end
end
