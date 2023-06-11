defmodule Footballratings.Workers.TeamProcessor do
  @moduledoc """
  Oban job that creates player rows for a given team.
  """
  use Oban.Worker, queue: :default

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"team_id" => team_id}}) do
    {:ok, [%{players: players}]} = FootballApi.team_squad(team_id)

    players
    |> Enum.map(&FootballApi.Processing.player_with_team(&1, team_id))
    |> Footballratings.FootballInfo.maybe_create_players()

    :ok
  end
end
