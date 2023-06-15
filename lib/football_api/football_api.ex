defmodule FootballApi do
  @moduledoc """
  Wrapper of the football API. Always returns the "response" field of the data
  as structs.
  """
  alias FootballApi.Models
  alias FootballApi.ResponseValidation
  require Logger

  defp client_impl() do
    Application.get_env(:footballratings, :api_client, FootballApi.FootballApiClient)
  end

  defp get_and_parse(url, url_query_params, decode_struct) do
    Logger.debug("Querying #{url} with #{query_args_to_string(url_query_params)}")

    with {:ok, response} <- client_impl().get(url, url_query_params),
         {:ok, result} <- ResponseValidation.validate_response(response, decode_struct) do
      {:ok, result.response}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Return all the matches for a given league, season and time range
  """
  def matches(league, season, from, to) do
    url_query_params = %{"league" => league, "season" => season, "from" => from, "to" => to}
    get_and_parse("/fixtures", url_query_params, Models.Matches.Struct.match())
  end

  @doc """
  Return lineups for a given match
  """
  def lineups(fixture_id) do
    url_query_params = %{"fixture" => fixture_id}
    get_and_parse("/fixtures/lineups", url_query_params, Models.Lineups.Struct.lineups())
  end

  @doc """
  Return player statistics for a specific fixture
  """
  def players_statistics(fixture_id) do
    url_query_params = %{"fixture" => fixture_id}

    get_and_parse(
      "/fixtures/players",
      url_query_params,
      Models.PlayersStatistics.Struct.players_statistics()
    )
  end

  @doc """
  Return a team squad
  """
  def team_squad(team_id) do
    url_query_params = %{"team" => team_id}
    get_and_parse("/players/squads", url_query_params, Models.Squads.Struct.squad())
  end

  defp query_args_to_string(query_args) do
    Enum.map_join(query_args, ", ", fn {k, v} -> "#{k}: #{v}" end)
  end
end
