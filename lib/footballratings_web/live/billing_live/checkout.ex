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
      <div class="text-xl font-semibold px-4">
        Subscribe for
        <FootballratingsWeb.PlanComponents.plan_billing
          currency={@plan.currency}
          amount={@plan.amount}
          frequency={@plan.frequency}
          frequency_type={@plan.frequency_type}
        />
      </div>
      <div id="cardPaymentBrick_container" phx-update="ignore"></div>
    </div>
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
  def handle_event("pay", params, %{assigns: assigns} = socket) do
    %{current_users: %{id: user_id}, plan: %{external_id: plan_id}} = assigns

    case create_subscription(params, plan_id, user_id) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Subscribed successfully!")
         |> redirect(to: ~p"/")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "An error occurred, please try again later")}
    end
  end

  defp create_subscription(params, plan_id, user_id) do
    with {:ok, external_subscription} <-
           MercadoPago.create_subscription(params, plan_id, user_id),
         {:ok, internal_subscription} <- Billing.create_subscription(external_subscription) do
      {:ok, internal_subscription}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
