defmodule FootballApi.Processing.Player do
  @moduledoc """
  Manages API-fetched Player information, such as filtering and processing
  before inserting into internal repo.
  """
  alias FootballApi.Models.Squads.Player

  def to_internal_schema(%Player{} = player) do
    Map.from_struct(player)
  end

  def insert_team_id(player, team_id) do
    Map.put(player, :team_id, team_id)
  end
end
