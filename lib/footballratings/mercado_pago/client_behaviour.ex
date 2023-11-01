defmodule Footballratings.MercadoPago.ClientBehaviour do
  @callback request(atom(), String.t()) ::
              {:ok, %Req.Response{}} | {:error, Exception.t()}
  @callback request(atom(), String.t(), map()) :: {:ok, %Req.Response{}} | {:error, Exception.t()}
end
