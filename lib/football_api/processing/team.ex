defmodule FootballApi.Processing.Team do
  @moduledoc """
  Manages API-fetched Team information, such as filtering and processing
  before inserting into internal repo.
  """

  def to_internal_schema(team), do: team
end
