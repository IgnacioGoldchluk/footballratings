defmodule FootballratingsWeb.MatchComponents do
  use Phoenix.Component

  def match_result(assigns) do
    ~H"""
    <div class="grid bg-secondary w-full">
      <div class="col-span-3 text-center text-xl py-2"><%= @match.league.name %> - <%= @match.season %></div>
      <div class="col-span-3 text-center text-xl"><%= @match.round %></div>
      <div class="flex col-span-3 items-center justify-between py-2 px-2">
        <FootballratingsWeb.TeamComponents.team_name_and_logo
          name={@match.home_team.name}
          id={@match.home_team.id} />
        <.result
          goals_home={@match.goals_home}
          goals_away={@match.goals_away}
          penalties_home={@match.penalties_home}
          penalties_away={@match.penalties_away}
        />
        <FootballratingsWeb.TeamComponents.team_name_and_logo
          name={@match.away_team.name}
          id={@match.away_team.id}
          reverse
          />
      </div>
    </div>
    """
  end

  attr(:goals_home, :integer, required: true)
  attr(:goals_away, :integer, required: true)
  attr(:penalties_home, :integer)
  attr(:penalties_away, :integer)

  def result(assigns) do
    ~H"""
    <%= if @penalties_home do %>
      <div class="text-xl">
        <%= @goals_home %> (<%= @penalties_home %>) - (<%= @penalties_away %>) <%= @penalties_home %>
      </div>
    <% else %>
      <div class="text-xl">
        <%= @goals_home %> - <%= @goals_away %>
        </div>
    <% end %>
    """
  end
end
