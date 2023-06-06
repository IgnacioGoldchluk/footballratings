defmodule FootballApi.Processing do
  def unique_leagues(matches) do
    matches
    |> Enum.map(&FootballApi.Processing.Match.extract_league/1)
    |> Enum.map(&FootballApi.Processing.League.to_internal_schema/1)
    |> Enum.uniq_by(& &1[:id])
  end

  def unique_teams(matches) do
    matches
    |> Enum.flat_map(&FootballApi.Processing.Match.extract_teams/1)
    |> Enum.map(&FootballApi.Processing.Team.to_internal_schema/1)
    |> Enum.uniq_by(&Map.get(&1, "id"))
  end

  def unique_matches(matches) do
    matches
    |> Enum.map(&FootballApi.Processing.Match.to_internal_schema/1)
    |> Enum.uniq_by(&Map.get(&1, "id"))
  end

  def match_finished?(match), do: FootballApi.Processing.Match.finished?(match)
end
