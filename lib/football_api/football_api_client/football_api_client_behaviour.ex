defmodule FootballApi.FootballApiClientBehaviour do
  @moduledoc """
  Behaviour for the 3rd party football data provider API.
  """

  @callback get(binary(), params: map()) ::
              {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}
end
