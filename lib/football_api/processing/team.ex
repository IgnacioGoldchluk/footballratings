defmodule FootballApi.Processing.Team do
  @moduledoc """
  Manages API-fetched Team information, such as filtering and processing
  before inserting into internal repo.
  """
  alias FootballApi.Models.Matches.{Team}

  def to_internal_schema(%Team{} = team) do
    Map.from_struct(team)
  end
end
