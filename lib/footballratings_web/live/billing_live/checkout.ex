defmodule FootballratingsWeb.BillingLive.Checkout do
  use FootballratingsWeb, :live_view

  alias Footballratings.Billing
  alias Footballratings.MercadoPago

  @impl true
  def render(assigns) do
    ~H"""
    <head>
      <script src="https://sdk.mercadopago.com/js/v2">
      </script>
    </head>
    <div id="plan-amount" class="hidden"><%= @plan.amount %></div>
    <div id="public-key" class="hidden"><%= @public_key %></div>
    <div id="main-checkout-container" phx-hook="Checkout">
      <div class="text-xl">
        Subscribe for
        <FootballratingsWeb.PlanComponents.plan_billing
          currency={@plan.currency}
          amount={@plan.amount}
          frequency={@plan.frequency}
          frequency_type={@plan.frequency_type}
        />
      </div>
      <div id="cardPaymentBrick_container"></div>
    </div>
    <button class="btn btn-primary text-white" onclick="window.createPayment()" id="payment-button">
      Pagar
    </button>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:public_key, MercadoPago.Client.public_key())
      |> assign(:plan, Billing.latest_active_plan())

    {:ok, socket}
  end

  @impl true
  def handle_event("pay", _params, socket) do
    # TODO: Create payment here
    {:noreply, socket}
  end
end
