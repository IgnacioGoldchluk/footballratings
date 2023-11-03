defmodule FootballratingsWeb.BillingController do
  use FootballratingsWeb, :controller

  alias Footballratings.Billing
  alias Footballratings.MercadoPago

  def checkout(conn, _params) do
    render(conn, :checkout, %{
      public_key: MercadoPago.Client.public_key(),
      plan: Billing.latest_active_plan()
    })
  end
end
