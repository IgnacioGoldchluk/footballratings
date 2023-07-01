defmodule FootballratingsWeb.MatchComponents do
  use Phoenix.Component

  def match_result(assigns) do
    ~H"""
      <.match match={@match} rate={false} />
    """
  end

  def match(assigns) do
    ~H"""
    <h2 class="font-semibold"><%= @match.league.name %> - <%= @match.round %></h2>
    <div class="join-vertical">
      <.team
        team={@match.home_team}
        goals={@match.goals_home}
        penalties={@match.penalties_home}
        match_id={@match.id}
        rate={@rate}
      />
      <.team
        team={@match.away_team}
        goals={@match.goals_away}
        penalties={@match.penalties_away}
        match_id={@match.id}
        rate={@rate}
      />
    </div>
    """
  end

  defp team(assigns) do
    ~H"""
    <div class="grid w-min bg-white border-solid border-2 border-primary join-item rounded-lg">
      <div class="flex justify-between flex-auto">
        <img src={"/images/team.jpg"} width="50" />
        <p class="w-48 font-semibold pl-4 py-2"><%= @team.name %></p>
        <.result goals={@goals} penalties={@penalties} />
        <%= if @rate do %>
        <.link navigate={"/matches/#{@match_id}/rate/#{@team.id}"} class="py-1 px-1">
          <button class="btn btn-primary">Rate players</button>
        </.link>
        <% end %>
      </div>
    </div>
    """
  end

  defp result(assigns) do
    ~H"""
    <%= if @penalties != nil do %>
      <p class="font-semibold w-16 py-2"><%= @goals %> (<%= @penalties %>)</p>
    <% else %>
      <p class="font-semibold w-16 py-2"><%= @goals %></p>
    <% end %>
    """
  end
end
