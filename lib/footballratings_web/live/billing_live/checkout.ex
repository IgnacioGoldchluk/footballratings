defmodule FootballratingsWeb.BillingLive.Checkout do
  use FootballratingsWeb, :live_view

  alias Footballratings.Billing

  @base_url "https://unoporuno.lemonsqueezy.com/checkout/buy/"

  @impl true
  def render(assigns) do
    ~H"""
    <a href={@checkout_url} class="lemonsqueezy-button">
      <.button class="btn btn-primary">
        Upgrade to Pro
      </.button>
    </a>
    <script src="https://assets.lemonsqueezy.com/lemon.js" defer>
    </script>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:plan, Billing.latest_active_plan())
      |> assign_checkout_url()

    {:ok, socket}
  end

  defp assign_checkout_url(%{assigns: %{current_users: user, plan: plan}} = socket) do
    url =
      "#{@base_url}#{plan.external_id}?embed=1&media=0&desc=0&discount=0&checkout[email]=#{user.email}&checkout[custom][user_id]=#{user.id}"

    assign(socket, :checkout_url, url)
  end
end
