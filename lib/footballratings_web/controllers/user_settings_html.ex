defmodule FootballratingsWeb.UserSettingsHTML do
  use FootballratingsWeb, :html

  def index(assigns) do
    ~H"""
    <div class="flex flex-col items-start gap-4">
      <.link href={~p"/user/settings/set-username"} class="hover:text-primary font-semibold text-xl">
        Set username
      </.link>
      <.link href={~p"/user/settings/checkout"} class="hover:text-primary font-semibold text-xl">
        Upgrade to pro
      </.link>
      <.link href={~p"/user/settings/subscriptions"} class="hover:text-primary font-semibold text-xl">
        Purchase history
      </.link>
    </div>
    """
  end
end
