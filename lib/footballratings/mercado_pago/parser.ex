defmodule Footballratings.MercadoPago.Parser do
  @moduledoc """
  Converts 3rd party API response objects into internal representation.
  """
  alias Footballratings.Billing

  def parse_plan(%{"auto_recurring" => recurring, "id" => id, "status" => status}) do
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

  def parse_plan(plan), do: {:error, "Invalid plan format received, #{Jason.encode!(plan)}"}

  def parse_subscription(%{"id" => id, "status" => status, "preapproval_plan_id" => plan_id}) do
    parsed = %{
      "external_id" => id,
      "status" => parse_subscription_status(status),
      "users_id" => Billing.get_subscription_by_external_id(id),
      "plan_id" => plan_id
    }

    {:ok, parsed}
  end

  def parse_subscription(sub), do: {:error, "Invalid subscription format #{Jason.encode!(sub)}"}

  defp parse_subscription_status("authorized"), do: "active"
  defp parse_subscription_status(status), do: status

  def to_subscription_data(%{
        "token" => token,
        "preapproval_plan_id" => plan_id,
        "payer" => %{"email" => payer_email}
      }) do
    data = %{
      "card_token_id" => token,
      "payer_email" => payer_email,
      "preapproval_plan_id" => plan_id
    }

    {:ok, data}
  end

  def to_subscription_data(sub), do: {:error, "Invalid subscription format #{Jason.encode!(sub)}"}

  def parse_created_subscription(%{
        "external_id" => id,
        "preapproval_plan_id" => plan_id,
        "status" => status
      }) do
    data = %{
      "external_id" => id,
      "plan_id" => plan_id,
      "status" => status
    }

    {:ok, data}
  end

  def parse_created_subscription(sub),
    do: {:error, "Invalid created subscription format #{Jason.encode!(sub)}"}
end
