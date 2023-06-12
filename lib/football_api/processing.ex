defmodule FootballApi.Processing do
  alias FootballApi.Processing.Player
  alias FootballApi.Models.PlayersStatistics

  @moduledoc """
  Module to process, filter and convert 3rd party API data to internal data
  """
  def unique_leagues(matches) do
    matches
    |> Enum.map(&FootballApi.Processing.Match.extract_league/1)
    |> Enum.map(&FootballApi.Processing.League.to_internal_schema/1)
    |> Enum.uniq_by(&Map.get(&1, :id))
  end

  def unique_teams(matches) do
    matches
    |> Enum.flat_map(&FootballApi.Processing.Match.extract_teams/1)
    |> Enum.map(&FootballApi.Processing.Team.to_internal_schema/1)
    |> Enum.uniq_by(&Map.get(&1, :id))
  end

  def unique_matches(matches) do
    matches
    |> Enum.map(&FootballApi.Processing.Match.to_internal_schema/1)
    |> Enum.uniq_by(&Map.get(&1, :id))
  end

  def match_finished?(match), do: FootballApi.Processing.Match.finished?(match)

  def coach_from_lineup(lineup), do: FootballApi.Processing.Lineups.extract_coach(lineup)

  def player_with_team(player, team_id) do
    player
    |> Player.to_internal_schema()
    |> Player.insert_team_id(team_id)
  end

  def player_match_schemas(%PlayersStatistics.Players{} = players_statistics, match_id) do
    players_that_played =
      FootballApi.Processing.PlayersStatistics.extract_players_that_played(players_statistics)

    players_that_played
    |> Enum.map(&FootballApi.Processing.PlayersStatistics.insert_match_id(&1, match_id))
  end

  def exclude_new_players_from_stats(players_stats) do
    # 3rd party API sometimes does not have data on new players.
    # These players have id=0, they must be filtered and ignored unfortunately.
    Enum.filter(players_stats, &(Map.get(&1, :player_id) != 0))
  end
end
