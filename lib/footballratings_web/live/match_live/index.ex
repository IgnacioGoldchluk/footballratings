defmodule FootballratingsWeb.MatchLive.Index do
  use FootballratingsWeb, :live_view
  alias Footballratings.FootballInfo

  @max_matches 10

  @impl true
  def mount(_params, _session, socket) do
    matches = FootballInfo.matches_available_for_rating()

    {:ok,
     stream(socket, :matches, matches,
       dom_id: &"matches-#{&1.match.id}",
       at: 0,
       limit: @max_matches
     )}
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
    <h2 class="font-semibold"><%= @match.league_name %> - <%= @match.match.round %></h2>
    <div class="join-vertical">
      <.team
        team={@match.home_team}
        goals={@match.match.goals_home}
        penalties={@match.match.penalties_home}
        match_id={@match.match.id}
      />
      <.team
        team={@match.away_team}
        goals={@match.match.goals_away}
        penalties={@match.match.penalties_away}
        match_id={@match.match.id}
      />
    </div>
    """
  end

  def team(assigns) do
    ~H"""
    <div class="grid w-min bg-white border-solid border-2 border-primary join-item">
      <div class="flex justify-between">
        <img src={"https://media.api-sports.io/football/teams/#{@team.id}.png"} width="50" />
        <p class="w-48 font-semibold pl-4 py-2"><%= @team.name %></p>
        <.result goals={@goals} penalties={@penalties} />
        <a href={"/matches/#{@match_id}/rate/#{@team.id}"} class="py-1 px-2">
          <button class="btn btn-primary">Rate players</button>
        </a>
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
