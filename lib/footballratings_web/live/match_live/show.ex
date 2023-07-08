defmodule FootballratingsWeb.MatchLive.Show do
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo
  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-2 items-center">
      <h2 class="font-semibold"><%= @match.league.name %> - <%= @match.round %></h2>
      <.link navigate={~p"/matches/#{@match.id}/rate/#{@match.home_team.id}"}>
        <FootballratingsWeb.MatchComponents.team
          team={@match.home_team}
          goals={@match.goals_home}
          penalties={@match.penalties_home}
          rate
        />
      </.link>
      <.link navigate={~p"/matches/#{@match.id}/rate/#{@match.away_team.id}"}>
        <FootballratingsWeb.MatchComponents.team
          team={@match.away_team}
          goals={@match.goals_away}
          penalties={@match.penalties_away}
          rate
        />
      </.link>
      <.link navigate={~p"/matches/#{@match.id}/statistics"}>
        <.button class="btn btn-primary">
          Ratings Statistics<span aria-hidden="true">→</span>
        </.button>
      </.link>
    </div>
    """
  end

  @impl true
  def mount(%{"match_id" => match_id}, _session, socket) do
    {:ok, socket |> assign_players(match_id) |> assign_match(match_id)}
  end

  defp assign_players(socket, match_id) do
    players =
      match_id
      |> String.to_integer()
      |> Footballratings.FootballInfo.players_for_match()

    assign(socket, :players, players)
  end

  defp assign_match(socket, match_id) do
    match =
      match_id
      |> String.to_integer()
      |> FootballInfo.get_match_with_team_and_league()

    assign(socket, :match, match)
  end
end
