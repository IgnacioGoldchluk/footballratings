defmodule FootballratingsWeb.TeamComponents do
  use Phoenix.Component

  attr(:name, :string, required: true)
  attr(:id, :integer, required: true)
  attr(:reverse, :boolean, default: false)

  def team_name_and_logo(%{reverse: false} = assigns) do
    ~H"""
    <img class="mask mask-circle" src="/images/team.jpg" width="50" />
    <div class="text-s"><%= @name %></div>
    """
  end

  def team_name_and_logo(%{reverse: true} = assigns) do
    ~H"""
    <div class="text-s"><%= @name %></div>
    <img class="mask mask-circle" src="/images/team.jpg" width="50" />
    """
  end
end
