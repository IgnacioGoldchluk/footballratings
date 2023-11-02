defmodule FootballratingsWeb.TeamComponents do
  @moduledoc """
  Components for `Team` records.
  """
  use Phoenix.Component

  attr(:name, :string, required: true)
  attr(:id, :integer, required: true)
  attr(:reverse, :boolean, default: false)

  def team_name_and_logo(%{reverse: false} = assigns) do
    ~H"""
    <img class="mask mask-circle" src={FootballApi.FootballApiImages.team_image(@id)} width="50" />
    <div class="text-s"><%= @name %></div>
    """
  end
end
