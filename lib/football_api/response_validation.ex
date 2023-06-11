defmodule FootballApi.ResponseValidation do
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
