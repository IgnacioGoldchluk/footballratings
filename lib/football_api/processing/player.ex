defmodule FootballApi.Processing.Player do
  @moduledoc """
  Manages API-fetched Player information, such as filtering and processing
  before inserting into internal repo.
  """
  alias FootballApi.Models.Squads.Player

  def to_internal_player_schema(%Player{} = player) do
    Map.from_struct(player)
  end

  def insert_team_id(player, team_id) do
    Map.put(player, :team_id, team_id)
  end

  def to_player_match_schemas(%{team: %{id: team_id}, players: players}, match_id) do
    players
    |> Enum.map(fn %{player: %{id: id}} = player ->
      %{
        "player_id" => id,
        "minutes_played" => player_minutes_played(player),
        "team_id" => team_id,
        "match_id" => match_id
      }
    end)
  end

  defp player_minutes_played(%{statistics: [%{games: %{minutes: minutes}}]}) do
    minutes
  end
end
