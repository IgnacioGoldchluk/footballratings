defmodule FootballApi.Processing.Team do
  alias FootballApi.Models.Matches.{Team}

  def to_internal_team_schema(%Team{} = team) do
    Map.from_struct(team)
  end
end
