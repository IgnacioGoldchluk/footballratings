defmodule FootballApi.Processing.Lineups do
  @moduledoc """
  Lineups processing
  """

  def extract_coach(%{"coach" => coach, "team" => %{"id" => team_id}}) do
    Map.put(coach, "team_id", team_id)
  end
end
