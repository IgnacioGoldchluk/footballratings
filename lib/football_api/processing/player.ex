defmodule FootballApi.Processing.Player do
  @moduledoc """
  Manages API-fetched Player information, such as filtering and processing
  before inserting into internal repo.
  """
  def to_internal_schema(player), do: player

  def insert_team_id(player, team_id) do
    Map.put(player, "team_id", team_id)
  end
end
