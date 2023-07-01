defmodule FootballratingsWeb.PlayerComponents do
  use FootballratingsWeb, :live_view
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <__MODULE__.player id={@assigns.id} name={@assigns.name} />
    """
  end

  attr(:name, :string, required: true)
  attr(:id, :integer, required: true)

  def player(assigns) do
    ~H"""
    <img class="mask mask-circle" src="/images/player.jpg" width="75" />
    <div class="text-m"><%= @name %></div>
    """
  end

  attr(:score, :integer, required: true)

  def score(assigns) do
    ~H"""
    <div class="flex justify-center rounded-lg border-2 border-primary bg-white w-24">
      <div class="text-2xl text-black">
        <%= @score %>
      </div>
    </div>
    """
  end

  def player_rating_box(assigns) do
    ~H"""
    <div class="flex flex-col justify-items-start px-2">
      <FootballratingsWeb.PlayerComponents.player name={@player.name} id={@player.id} />
    </div>
    <div class="flex items-center pl-10">
      <FootballratingsWeb.PlayerComponents.score score={@score} />
    </div>
    """
  end

  attr(:id, :integer, required: true)
  attr(:name, :string, required: true)

  def player_link(assigns) do
    ~H"""
    <.link navigate={~p"/players/#{@id}"} class="hover:text-primary">
      <%= @name %>
    </.link>
    """
  end
end
