defmodule Footballratings.MercadoPago do
  alias Footballratings.MercadoPago
  alias Footballratings.MercadoPago.Parser

  defp api_client(),
    do: Application.get_env(:footballratings, :mercado_pago_client, MercadoPago.Client)

  def get_plan(id) do
    endpoint = "/preapproval_plan/#{id}"

    with {:ok, %Req.Response{body: body}} <- api_client().request(:get, endpoint),
         {:ok, plan} <- Parser.parse_plan(body) do
      {:ok, plan}
    else
      {:error, exception} -> {:error, exception}
    end
  end

  def get_subscription(id) do
    endpoint = "/preapproval/#{id}"

    with {:ok, %Req.Response{body: body}} <- api_client().request(:get, endpoint),
         {:ok, subscription} <- Parser.parse_subscription(body) do
      {:ok, subscription}
    else
      {:error, exception} -> {:error, exception}
    end
  end
end
