defmodule FootballApi.Processing.Lineups do
  alias FootballApi.Models.Lineups

  def extract_coach(%Lineups.Lineup{coach: coach}) do
    Map.from_struct(coach)
  end
end
