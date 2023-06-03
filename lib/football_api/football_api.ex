defmodule FootballApi do
  alias FootballApi.FootballApiClient

  @doc """
  Return all the matches for a given league, season and time range
  """
  def matches(league, season, from, to) do
    url_query_params = %{"league" => league, "season" => season, "from" => from, "to" => to}
    {:ok, response} = FootballApiClient.get("/fixtures", [], params: url_query_params)
    {:ok, response} = Poison.decode(response.body, as: FootballApi.Models.Matches.Struct.match())

    response
  end

  @doc """
  Return lineups for a given match
  """
  def lineups_by_fixture_id(fixture_id) do
    url_query_params = %{"fixture" => fixture_id}
    {:ok, response} = FootballApiClient.get("/fixtures/lineups", [], params: url_query_params)

    {:ok, response} =
      Poison.decode(response.body, as: FootballApi.Models.Lineups.Struct.lineups())

    response
  end

  @doc """
  Return player statistics for a specific fixture
  """
  def players_statistics(fixture_id) do
    url_query_params = %{"fixture" => fixture_id}
    {:ok, response} = FootballApiClient.get("/fixtures/players", [], params: url_query_params)

    {:ok, response} =
      Poison.decode(response.body,
        as: FootballApi.Models.PlayersStatistics.Struct.players_statistics()
      )

    response
  end
end
