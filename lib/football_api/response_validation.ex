defmodule FootballApi.ResponseValidation do
  @moduledoc """
  Validates responses from 3rd party API, since they tend to be a bit unreliable.
  """

  def validate_response(%HTTPoison.Response{} = response, json_schema) do
    with {:ok, response} <- validate_headers(response),
         {:ok, response} <- validate_status(response),
         {:ok, %HTTPoison.Response{body: response_body}} <- validate_no_errors(response),
         {:ok, response_body} <- Jason.decode(response_body),
         {:ok, response_body} <- validate_schema(response_body, json_schema),
         {:ok, response_body} <- extract_response(response_body) do
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

  defp validate_schema(body, json_schema) do
    case JsonXema.validate(json_schema, body) do
      :ok -> {:ok, body}
      {:error, %JsonXema.ValidationError{}} = error -> error
    end
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
      nil -> {:ok, response}
      errors -> {:error, "Received #{errors} in X-Api-Errors in #{request_url}"}
    end
  end

  defp validate_no_errors(%HTTPoison.Response{body: body} = response) do
    {:ok, %{"errors" => errors}} = Jason.decode(body)

    case errors do
      [] -> {:ok, response}
      nil -> {:ok, response}
      error_map when error_map == %{} -> {:ok, response}
      error_map -> {:error, format_errors(error_map)}
    end
  end

  defp format_errors(errors) do
    errors
    |> Enum.map_join(", ", fn {err_type, err_val} -> "#{err_type} #{err_val}" end)
  end

  defp extract_response(%{"response" => response}), do: {:ok, response}
  defp extract_response(_body), do: {:error, "Response not found"}
end
