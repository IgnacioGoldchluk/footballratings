defmodule Footballratings.MercadoPago.Client do
  @behaviour Footballratings.MercadoPago.ClientBehaviour
  @base_url "https://api.mercadopago.com"

  defp get_config() do
    Application.get_application(__MODULE__)
    |> Application.get_env(MercadoPago)
  end

  def public_key(), do: get_config() |> Keyword.get(:public_key)
  defp access_token(), do: get_config() |> Keyword.get(:access_token)

  defp new() do
    Req.new(
      base_url: @base_url,
      auth: {:bearer, access_token()}
    )
  end

  def request(method, endpoint, body \\ nil) do
    new()
    |> Req.update(method: method, url: endpoint, body: body)
    |> Req.request()
  end
end
