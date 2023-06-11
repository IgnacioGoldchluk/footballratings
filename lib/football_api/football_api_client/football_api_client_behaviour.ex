defmodule FootballApi.FootballApiClientBehaviour do
  @callback get(binary(), params: map()) ::
              {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}
end
