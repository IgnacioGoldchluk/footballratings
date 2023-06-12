defmodule Footballratings.Workers.StatisticsProcessor do
  @moduledoc """
  Oban job that fetches players statistics for a given match (both teams)
  and fills the database.
  """
  use Oban.Worker, queue: :default

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"match_id" => match_id}}) do
    {:ok, statistics} = FootballApi.players_statistics(match_id)

    statistics
    |> Enum.flat_map(&FootballApi.Processing.player_match_schemas(&1, match_id))
    # Temporal
    |> FootballApi.Processing.exclude_new_players_from_stats()
    |> Footballratings.FootballInfo.create_players_matches()

    Footballratings.FootballInfo.set_match_status_to_ready(match_id)
    :ok
  end
end
