defmodule FootballratingsWeb.MatchLive.Index do
  use FootballratingsWeb, :live_view
  alias Footballratings.FootballInfo

  @impl true
  def mount(_params, _session, socket) do
    matches = FootballInfo.matches_available_for_rating()

    {:ok, stream(socket, :matches, matches, at: 0)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="matches" phx-update="stream">
      <div
        :for={{dom_id, available_match} <- @streams.matches}
        id={dom_id}
        class="grid grid-flow-rows auto-rows-auto w-min py-2 px-2"
      >
        <div class="py-2 px-2 bg-secondary">
          <.match match={available_match} />
        </div>
      </div>
    </div>
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
      />
      <.team
        team={@match.away_team}
        goals={@match.goals_away}
        penalties={@match.penalties_away}
        match_id={@match.id}
      />
    </div>
    """
  end

  def team(assigns) do
    ~H"""
    <div class="grid w-min bg-white border-solid border-2 border-primary join-item rounded-lg">
      <div class="flex justify-between flex-auto">
        <img src={"https://media.api-sports.io/football/teams/#{@team.id}.png"} width="50" />
        <p class="w-48 font-semibold pl-4 py-2"><%= @team.name %></p>
        <.result goals={@goals} penalties={@penalties} />
        <.link navigate={"/matches/#{@match_id}/rate/#{@team.id}"} class="py-1 px-1">
          <button class="btn btn-primary">Rate players</button>
        </.link>
      </div>
    </div>
    """
  end

  def result(assigns) do
    ~H"""
    <%= if @penalties != nil do %>
      <p class="font-semibold w-16 py-2"><%= @goals %> (<%= @penalties %>)</p>
    <% else %>
      <p class="font-semibold w-16 py-2"><%= @goals %></p>
    <% end %>
    """
  end
end
