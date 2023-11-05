defmodule FootballratingsWeb.SubscriptionHTML do
  use FootballratingsWeb, :html

  def index(assigns) do
    ~H"""
    <FootballratingsWeb.SubscripionComponents.subscriptions_table subscriptions={@subscriptions} />
    """
  end
end
