defmodule FootballratingsWeb.PlayerComponents do
  use Phoenix.Component

  alias Footballratings.FootballInfo.Player

  attr(:name, :string, required: true)
  attr(:id, :integer, required: true)

  def player(assigns) do
    ~H"""
    <img class="mask mask-circle" src="/images/player.jpg" width="75" />
    <div class="text-xl"><%= @name %></div>
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
end
