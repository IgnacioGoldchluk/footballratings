defmodule FootballratingsWeb.MatchLive.Show do
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo
  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-2 items-center">
      <h2 class="font-semibold"><%= @match.league.name %> - <%= @match.round %></h2>

      <%= if @match.status == :ready do %>
        <div class="text-info font-semibold">Click on a team to rate its players</div>
        <.link navigate={~p"/matches/#{@match.id}/rate/#{@match.home_team.id}"}>
          <.home_team match={@match} />
        </.link>
        <.link navigate={~p"/matches/#{@match.id}/rate/#{@match.away_team.id}"}>
          <.away_team match={@match} />
        </.link>
      <% else %>
        <.home_team match={@match} />
        <.away_team match={@match} />
      <% end %>
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
    {:ok, socket |> assign_match(match_id)}
  end

  defp assign_match(socket, match_id) do
    match =
      match_id
      |> String.to_integer()
      |> FootballInfo.get_match_with_team_and_league()

    case match do
      nil -> socket |> put_flash(:error, "Match not found") |> redirect(to: "/")
      ^match -> assign(socket, :match, match)
    end
  end

  defp home_team(assigns) do
    ~H"""
    <FootballratingsWeb.MatchComponents.team
      team={@match.home_team}
      goals={@match.goals_home}
      penalties={@match.penalties_home}
    />
    """
  end

  defp away_team(assigns) do
    ~H"""
    <FootballratingsWeb.MatchComponents.team
      team={@match.away_team}
      goals={@match.goals_away}
      penalties={@match.penalties_away}
    />
    """
  end
end
