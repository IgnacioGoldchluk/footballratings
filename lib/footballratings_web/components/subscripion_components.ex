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
      # Good
      :on_trial -> "text-green-600"
      :active -> "text-green-600"
      # Neutral
      :paused -> "text-neutral-400"
      :cancelled -> "text-neutral-400"
      # Warning
      :past_due -> "text-yellow-300"
      :unpaid -> "text-yellow-300"
      # Bad
      :expired -> "text-red-600"
    end
  end
end
