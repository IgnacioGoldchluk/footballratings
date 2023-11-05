defmodule FootballratingsWeb.SubscriptionController do
  use FootballratingsWeb, :controller

  alias Footballratings.Billing

  def index(conn, _params) do
    %{id: user_id} = conn.assigns[:current_users]

    subscriptions = Billing.subscriptions_for_user(user_id)
    render(conn, :index, %{subscriptions: subscriptions})
  end
end
