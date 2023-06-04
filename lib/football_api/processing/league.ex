defmodule FootballApi.Processing.League do
  alias FootballApi.Models.Matches.{League}

  def to_internal_league_schema(%League{} = league), do: Map.from_struct(league)
end
