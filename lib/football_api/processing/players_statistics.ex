defmodule FootballApi.Processing.PlayersStatistics do
  alias FootballApi.Models.PlayersStatistics, as: Stats

  def extract_players_that_played(%Stats.Players{players: players, team: %{id: team_id}}) do
    players
    |> Enum.map(&to_internal_schema/1)
    |> Enum.map(&insert_team_id(&1, team_id))
    |> Enum.filter(&played?/1)
  end

  defp insert_team_id(player, team_id) do
    Map.put(player, :team_id, team_id)
  end

  defp to_internal_schema(player) do
    %{
      player_id: player_id(player),
      minutes_played: minutes_played(player)
    }
  end

  defp player_id(%Stats.Player{player: %Stats.PlayerInfo{id: player_id}}) do
    player_id
  end

  defp minutes_played(%Stats.Player{
         statistics: [%Stats.Games{games: %Stats.GameStatistics{minutes: minutes}}]
       }) do
    minutes
  end

  defp played?(%{minutes_played: minutes_played}), do: minutes_played != nil

  def insert_match_id(players, match_id) do
    players
    |> Map.put(:match_id, match_id)
  end
end
