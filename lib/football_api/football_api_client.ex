defmodule FootballApi.FootballApiClient do
  @moduledoc """
  Custom client for Football API
  """
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

  def validate_response(%HTTPoison.Response{} = response, decode_struct) do
    with {:ok, response} <- validate_headers(response),
         {:ok, response} <- validate_status(response),
         {:ok, response_body} <- Poison.decode(response.body, as: decode_struct) do
      {:ok, response_body}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_status(%HTTPoison.Response{status_code: 200} = response) do
    {:ok, response}
  end

  defp validate_status(%HTTPoison.Response{status_code: status, request_url: request_url}) do
    {:error, "#{request_url}: response status=#{status}, expected 200"}
  end

  defp x_api_errors_value(headers) do
    Enum.find_value(headers, fn
      {"X-Api-Errors", value} -> value
      {_, _} -> nil
    end)
  end

  defp validate_headers(
         %HTTPoison.Response{headers: headers, request_url: request_url} = response
       ) do
    case x_api_errors_value(headers) do
      "0" -> {:ok, response}
      errors -> {:error, "Received #{errors} in X-Api-Errors in #{request_url}"}
    end
  end
end
