defmodule Footballratings.MercadoPago.WebhookHandler do
  @moduledoc """
  Receives webhook notifications and delegates to workers.
  """
  alias Footballratings.MercadoPago.Workers

  def handle(req) when is_map_key(req, "type"), do: handle(req["type"], req)

  defp handle("subscription_preapproval_plan", %{"data" => data}) do
    res =
      data
      |> Workers.CreatePlan.new()
      |> Oban.insert()

    case res do
      {:ok, _} -> :ok
      {:error, _} -> :error
    end
  end
end
