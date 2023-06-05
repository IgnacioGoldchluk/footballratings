defmodule FootballApi.Processing do
  def unique_leagues(matches) do
    matches
    |> Enum.map(&FootballApi.Processing.Match.extract_league/1)
    |> Enum.map(&FootballApi.Processing.League.to_internal_schema/1)
    |> Enum.uniq_by(&Map.get(&1, "id"))
  end

  def unique_teams(matches) do
    matches
    |> Enum.flat_map(&FootballApi.Processing.Match.extract_teams/1)
    |> Enum.map(&FootballApi.Processing.Team.to_internal_schema/1)
    |> Enum.uniq_by(&Map.get(&1, "id"))
  end

  def unique_matches(matches) do
    matches
    |> Enum.map(&FootballApi.Processing.Match.to_internal_match_schema/1)
    |> Enum.uniq_by(&Map.get(&1, "id"))
  end

  def finished_matches(matches) do
    matches
    |> Enum.filter(&FootballApi.Processing.Match.finished?/1)
  end
end
