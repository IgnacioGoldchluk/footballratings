defmodule Footballratings.MercadoPago.ClientBehaviour do
  @moduledoc """
  Behaviour for a MercadoPago client.
  """

  @callback request(atom(), String.t()) ::
              {:ok, %Req.Response{}} | {:error, Exception.t()}
  @callback request(atom(), String.t(), map()) :: {:ok, %Req.Response{}} | {:error, Exception.t()}
end
