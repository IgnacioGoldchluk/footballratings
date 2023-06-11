defmodule FootballApi.FootballApiClient do
  @behaviour FootballApi.FootballApiClientBehaviour

  @impl FootballApi.FootballApiClientBehaviour
  def get(url, url_query_params) do
    FootballApi.FootballApiClient.FootballApiClientBase.get(url, [], params: url_query_params)
  end
end
