defmodule FootballratingsWeb.MatchComponents do
  use FootballratingsWeb, :html
  use Phoenix.Component

  def matches_table(assigns) do
    ~H"""
    <.table
      id="matches"
      rows={@matches}
      row_click={fn {_id, match_id} -> JS.navigate(~p"/matches/#{match_id}") end}
    >
      <:col :let={{_id, match}} label="League"><%= acronym(match.league.name) %></:col>
      <:col :let={{_id, match}} label="Home Team"><%= match.home_team.name %></:col>
      <:col :let={{_id, match}} label="Result"><%= result_row(match) %></:col>
      <:col :let={{_id, match}} label="Away Team"><%= match.away_team.name %></:col>
      <:col :let={{_id, match}} label="Round"><%= match.round %></:col>
    </.table>
    <div id="infinite-scroll-marker" phx-hook="InfiniteScroll"></div>
    """
  end

  def match_result(assigns) do
    ~H"""
    <h2 class="font-semibold"><%= @match.league.name %> - <%= @match.round %></h2>
    <div class="join-vertical">
      <.team team={@match.home_team} goals={@match.goals_home} penalties={@match.penalties_home} />
      <.team team={@match.away_team} goals={@match.goals_away} penalties={@match.penalties_away} />
    </div>
    """
  end

  attr(:team, :any, required: true)
  attr(:goals, :integer, required: true)
  attr(:penalties, :any, required: true)
  attr(:pinned, :boolean, default: false)

  def team(assigns) do
    ~H"""
    <div class={"flex w-64 #{team_bg(@pinned)} border-solid border-2 border-primary justify-between pr-2 gap-2 hover:bg-secondary"}>
      <img src="/images/team.jpg" width="50" />
      <p class="font-semibold py-2"><%= @team.name %></p>
      <.result goals={@goals} penalties={@penalties} />
    </div>
    """
  end

  defp team_bg(true), do: "bg-secondary"
  defp team_bg(false), do: "bg-white"

  def result_row(%{penalties_home: nil, penalties_away: nil} = match) do
    "#{match.goals_home} - #{match.goals_away}"
  end

  # Match with pens
  def result_row(match) do
    "#{match.goals_home} (#{match.penalties_home}) - (#{match.penalties_away}) #{match.goals_away}"
  end

  def acronym(words) do
    words
    |> String.split()
    |> Enum.map(&String.first/1)
    |> Enum.join("")
  end

  defp result(assigns) do
    ~H"""
    <%= if @penalties != nil do %>
      <p class="font-semibold py-2"><%= @goals %> (<%= @penalties %>)</p>
    <% else %>
      <p class="font-semibold py-2"><%= @goals %></p>
    <% end %>
    """
  end
end
