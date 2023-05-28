defmodule FootballRatings.FootballAPI do
  use HTTPoison.Base

  @endpoint "https://v3.football.api-sports.io"

  defp api_sports_key() do
    System.get_env("API_SPORTS_KEY")
  end

  def process_request_headers(_headers) do
    # As per Sports API documentation, it only supports 3 headers.
    ["x-rapidapi-key": api_sports_key()]
  end

  def process_request_url(url), do: @endpoint <> url
end
