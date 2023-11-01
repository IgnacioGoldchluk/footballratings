defmodule Footballratings.MercadoPago do
  alias Footballratings.MercadoPago

  def api_client(),
    do: Application.get_env(:footballratings, :mercado_pago_client, MercadoPago.Client)

  def get_plan(id) do
    endpoint = "/preapproval_plan/#{id}"

    with {:ok, %Req.Response{body: body}} <- api_client().request(:get, endpoint),
         {:ok, plan} <- parse_plan(body) do
      {:ok, plan}
    else
      {:error, exception} -> {:error, exception}
    end
  end

  defp parse_plan(%{"auto_recurring" => recurring, "id" => id, "status" => status} = _plan) do
    formatted_plan = %{
      "external_id" => id,
      "status" => status,
      "frequency" => Map.get(recurring, "frequency"),
      "frequency_type" => Map.get(recurring, "frequency_type"),
      "amount" => Map.get(recurring, "transaction_amount") |> trunc(),
      "currency" => Map.get(recurring, "currency_id")
    }

    {:ok, formatted_plan}
  end

  defp parse_plan(plan), do: {:error, "Plan returned invalid contents: #{IO.inspect(plan)}"}
end
