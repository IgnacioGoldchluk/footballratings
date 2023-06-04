defmodule Footballratings.Workers.StatisticsProcessor do
  use Oban.Worker, queue: :default

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"match_id" => match_id}}) do
    {:ok, statistics} = FootballApi.players_statistics(match_id)

    statistics
    |> Enum.flat_map(&FootballApi.Processing.Player.to_player_match_schemas(&1, match_id))
    |> Footballratings.FootballInfo.create_players_match()

    :ok
  end
end
