defmodule FootballApi.FootballApiClient do
  use HTTPoison.Base

  @endpoint "https://v3.football.api-sports.io"

  defp api_sports_key(), do: System.get_env("API_SPORTS_KEY")

  def process_request_headers(_headers) do
    # API Football only supports GET requests and 3 headers:
    # "x-rapidapi-host"
    # "x-rapidapi-key"
    # "x-apisports-key"

    # We default to using "x-rapidapi-key" header only
    ["x-rapidapi-key": api_sports_key()]
  end

  def process_request_url(url), do: @endpoint <> url
end
