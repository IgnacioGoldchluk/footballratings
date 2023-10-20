defmodule Footballratings.Workers.TeamProcessor do
  @moduledoc """
  Oban job that creates player rows for a given team.
  """
  use Oban.Worker, queue: :default

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "home_team_id" => home_team_id,
          "away_team_id" => away_team_id,
          "match_id" => match_id
        }
      }) do
    [home_team_id, away_team_id]
    |> Enum.each(fn team_id ->
      {:ok, [%{"players" => players}]} = FootballApi.team_squad(team_id)

      players
      |> Enum.map(&FootballApi.Processing.player_with_team(&1, team_id))
      |> Footballratings.FootballInfo.maybe_create_players()
    end)

    Footballratings.JobCreator.new_job_for_match_statistics(%{"match_id" => match_id})
    :ok
  end
end
