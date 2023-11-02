defmodule Footballratings.MercadoPago.Workers.CreatePlan do
  @moduledoc """
  Fetches plans from the 3rd party provider and inserts them into the DB.
  """
  use Oban.Worker

  alias Footballratings.{Billing, MercadoPago}

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => external_id}}) do
    {:ok, plan_data} = MercadoPago.get_plan(external_id)
    {:ok, _} = Billing.create_plan(plan_data)
    :ok
  end
end
