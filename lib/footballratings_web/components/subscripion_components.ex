defmodule FootballratingsWeb.SubscripionComponents do
  use FootballratingsWeb, :html
  use Phoenix.Component

  def subscriptions_table(assigns) do
    ~H"""
    <.table id="subscriptions-table" rows={@subscriptions}>
      <:col :let={sub} label="Status"><.subscription_status status={sub.status} /></:col>
      <:col :let={sub} label="Created at"><%= sub.inserted_at %></:col>
      <:col :let={sub} label="Last updated"><%= sub.updated_at %></:col>
    </.table>
    """
  end

  defp subscription_status(assigns) do
    ~H"""
    <div class={"text-l #{status_color(@status)} font-semibold"}><%= @status %></div>
    """
  end

  defp status_color(status) do
    case status do
      :active -> "text-green-600"
      :pending -> "text-neutral-400"
      :cancelled -> "text-red-600"
      :paused -> "text-yellow-300"
    end
  end
end
