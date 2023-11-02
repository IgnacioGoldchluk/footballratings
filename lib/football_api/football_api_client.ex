defmodule FootballApi.FootballApiClient do
  @moduledoc """
  Base implementation of the 3rd party API client.
  """

  @behaviour FootballApi.FootballApiClientBehaviour

  @impl FootballApi.FootballApiClientBehaviour
  def get(url, url_query_params) do
    FootballApi.FootballApiClient.FootballApiClientBase.get(url, [], params: url_query_params)
  end
end
