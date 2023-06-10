defmodule FootballApi.Processing.Lineups do
  @moduledoc """
  Lineups processing
  """
  alias FootballApi.Models.Lineups

  def extract_coach(%Lineups.Lineup{coach: coach}) do
    Map.from_struct(coach)
  end
end
