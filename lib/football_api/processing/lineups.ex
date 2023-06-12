defmodule FootballApi.Processing.Lineups do
  @moduledoc """
  Lineups processing
  """
  alias FootballApi.Models.Lineups

  def extract_coach(%Lineups.Lineup{coach: coach, team: %{id: team_id}}) do
    Map.from_struct(coach) |> Map.put(:team_id, team_id)
  end
end
