defmodule FootballApi.Processing.League do
  @moduledoc """
  Manages API-fetched League information, such as filtering and processing
  before inserting into internal repo.
  """

  alias FootballApi.Models.Matches.{League}

  def to_internal_league_schema(%League{} = league), do: Map.from_struct(league)
end
