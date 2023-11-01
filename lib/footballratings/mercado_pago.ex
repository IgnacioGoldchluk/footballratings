defmodule Footballratings.MercadoPago do
  alias Footballratings.MercadoPago

  def get_plan(id) do
    MercadoPago.Client.request(:get, "/preapproval_plan/#{id}")
    |> parse_plan()
  end

  def parse_plan(%{"auto_recurring" => recurring, "id" => id, "status" => status} = _plan) do
    %{
      "external_id" => id,
      "status" => status,
      "frequency" => Map.get(recurring, "frequency"),
      "frequency_type" => Map.get(recurring, "frequency_type"),
      "amount" => Map.get(recurring, "transaction_amount") |> trunc(),
      "currency" => Map.get(recurring, "currency_id")
    }
  end
end
