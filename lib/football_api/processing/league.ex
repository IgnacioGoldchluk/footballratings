defmodule FootballApi.Processing.League do
  @moduledoc """
  Manages API-fetched League information, such as filtering and processing
  before inserting into internal repo.
  """

  def to_internal_schema(league), do: Map.delete(league, "round")
end
