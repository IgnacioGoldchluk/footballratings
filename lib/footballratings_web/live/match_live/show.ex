defmodule FootballratingsWeb.MatchLive.Show do
  use FootballratingsWeb, :live_view
  # use Phoenix.Component
  # use Phoenix.HTML

  alias Footballratings.FootballInfo

  def render(assigns) do
    ~H"""
    <.match match={@match} />
    """
  end

  def mount(%{"id" => match_id}, _session, socket) do
    {:ok,
     assign(
       socket,
       :match,
       FootballInfo.get_match_with_team_and_league(String.to_integer(match_id))
     )}
  end

  def match(assigns) do
    ~H"""
    <a href={"/matches/#{@match.match.id}"}>
      <div class="card w-auto bg-secondary text-primary-content hover:bg-secondary-focus">
        <div class="card-actions justify-center px-3 pt-3">
          <.home_team team={@match.home_team} />
          <.match_result match={@match.match} />
          <.away_team team={@match.away_team} />
        </div>
      </div>
    </a>
    """
  end

  def match_result(assigns) do
    ~H"""
    <%= if @match.penalties_home != nil do %>
      <p class="py-7 text-3xl"><%= result_with_penalties(@match) %></p>
    <% else %>
      <p class="py-7 text-3xl"><%= result_without_penalties(@match) %></p>
    <% end %>
    """
  end

  defp result_with_penalties(match) do
    "#{match.goals_home} (#{match.penalties_home}) - (#{match.penalties_away}) #{match.goals_away}"
  end

  defp result_without_penalties(match) do
    "#{match.goals_home} - #{match.goals_away}"
  end

  def home_team(assigns) do
    ~H"""
    <p class="py-7 text-2xl"><%= @team.name %></p>
    <img src={"https://media.api-sports.io/football/teams/#{@team.id}.png"} width="75" height="75" />
    """
  end

  def away_team(assigns) do
    ~H"""
    <img src={"https://media.api-sports.io/football/teams/#{@team.id}.png"} width="75" height="75" />
    <p class="py-7 text-2xl"><%= @team.name %></p>
    """
  end
end
