defmodule Footballratings.Workers.StatisticsProcessor do
  @moduledoc """
  Oban job that fetches players statistics for a given match (both teams)
  and fills the database.
  """
  use Oban.Worker, queue: :default

  alias Footballratings.FootballInfo
  alias Footballratings.FootballInfo.Match

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"match_id" => match_id}}) do
    :ok = create_players_matches(match_id)
    :ok = create_coaches_matches(match_id)

    {:ok, %Match{} = match} = Footballratings.FootballInfo.set_match_status_to_ready(match_id)
    Footballratings.Notifiers.Match.broadcast_new_match(match)
    :ok
  end

  defp create_players_matches(match_id) do
    {:ok, statistics} = FootballApi.players_statistics(match_id)

    statistics
    |> Enum.flat_map(&FootballApi.Processing.player_match_schemas(&1, match_id))
    # Temporal
    |> FootballApi.Processing.exclude_new_players_from_stats()
    |> Enum.filter(fn %{player_id: player_id} -> FootballInfo.player_exists?(player_id) end)
    |> Footballratings.FootballInfo.create_players_matches()

    :ok
  end

  defp create_coaches_matches(_match_id) do
    # {:ok, lineups} = FootballApi.lineups(match_id)

    # coaches = Enum.map(lineups, &FootballApi.Processing.coach_from_lineup/1)
    # Footballratings.FootballInfo.maybe_create_coaches(coaches)

    # coaches
    # |> Enum.map(&FootballApi.Processing.to_coach_match(&1, match_id))
    # |> Footballratings.FootballInfo.create_coaches_matches()

    :ok
  end
end
