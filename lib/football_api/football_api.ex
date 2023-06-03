defmodule FootballApi do
  alias FootballApi.FootballApiClient
  alias FootballApi.Models

  @doc """
  Return all the matches for a given league, season and time range
  """
  def matches(league, season, from, to) do
    url_query_params = %{"league" => league, "season" => season, "from" => from, "to" => to}
    {:ok, response} = FootballApiClient.get("/fixtures", [], params: url_query_params)
    {:ok, response} = Poison.decode(response.body, as: Models.Matches.Struct.match())

    response
  end

  @doc """
  Return lineups for a given match
  """
  def lineups_by_fixture_id(fixture_id) do
    url_query_params = %{"fixture" => fixture_id}
    {:ok, response} = FootballApiClient.get("/fixtures/lineups", [], params: url_query_params)

    {:ok, response} = Poison.decode(response.body, as: Models.Lineups.Struct.lineups())

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
        as: Models.PlayersStatistics.Struct.players_statistics()
      )

    response
  end

  @doc """
  Return a team squad
  """
  def team_squad(team_id) do
    url_query_params = %{"team" => team_id}
    {:ok, response} = FootballApiClient.get("/players/squads", [], params: url_query_params)
    {:ok, response} = Poison.decode(response.body, as: Models.Squads.Struct.squad())

    response
  end
end
