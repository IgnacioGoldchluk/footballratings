defmodule FootballApi.Processing.PlayersStatistics do
  def extract_players_that_played(%{"players" => players, "team" => %{"id" => team_id}}) do
    players
    |> Enum.map(&to_internal_schema/1)
    |> Enum.map(&insert_team_id(&1, team_id))
    |> Enum.filter(&played?/1)
  end

  defp insert_team_id(player, team_id) do
    Map.put(player, "team_id", team_id)
  end

  defp to_internal_schema(player) do
    %{
      "player_id" => player_id(player),
      "minutes_played" => minutes_played(player)
    }
  end

  defp player_id(%{"player" => %{"id" => player_id}}), do: player_id

  defp minutes_played(%{"statistics" => [%{"games" => %{"minutes" => minutes}}]}), do: minutes

  defp played?(%{"minutes_played" => minutes_played}), do: minutes_played != nil

  def insert_match_id(players, match_id) do
    players
    |> Map.put("match_id", match_id)
  end
end
