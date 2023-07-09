defmodule FootballratingsWeb.TeamLive.Show do
  use FootballratingsWeb, :live_view
  alias Footballratings.FootballInfo
  alias Footballratings.Ratings

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center gap-2">
      <div class="flex flex-col gap-2 items-center max-sm">
        <FootballratingsWeb.TeamComponents.team_name_and_logo
          name={@team_with_players.name}
          id={@team_with_players.id}
        />
      </div>
      <.link navigate={~p"/teams/#{@team_with_players.id}/players"}>
        <.button class="btn btn-primary">Players <span aria-hidden="true">→</span></.button>
      </.link>
      <.link navigate={~p"/teams/#{@team_with_players.id}/matches"}>
        <.button class="btn btn-primary">Matches <span aria-hidden="true">→</span></.button>
      </.link>

      <div class="stats stats-vertical lg:stats-horizontal shadow">
        <div class="stat">
          <div class="stat-title">Matches registered</div>
          <div class="stat-value"><%= @stats.total_matches %></div>
          <div class="stat-desc">For this team</div>
        </div>

        <div class="stat">
          <div class="stat-title">Ratings registered</div>
          <div class="stat-value"><%= @stats.total_ratings %></div>
          <div class="stat-desc">Unique ratings for this team</div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(%{"team_id" => team_id}, _session, socket) do
    socket =
      socket
      |> assign_team_with_players(team_id)
      |> assign_matches_for_team(team_id)
      |> assign(:current_section, "Players")
      |> assign_stats()

    {:ok, socket}
  end

  defp assign_matches_for_team(socket, team_id) do
    assign(
      socket,
      :matches_for_team,
      team_id |> String.to_integer() |> FootballInfo.matches_for_team()
    )
  end

  defp assign_stats(%{assigns: %{team_with_players: %{id: team_id}}} = socket) do
    total_matches = FootballInfo.count_matches_for_team(team_id)
    total_ratings = Ratings.count_match_ratings_for_team(team_id)

    stats = %{total_matches: total_matches, total_ratings: total_ratings}
    assign(socket, :stats, stats)
  end

  defp assign_team_with_players(socket, team_id) do
    team_with_players =
      team_id
      |> String.to_integer()
      |> FootballInfo.team_with_players()

    assign(socket, :team_with_players, team_with_players)
  end

  @impl true
  def handle_event("section_selected", %{"player_or_match" => value}, socket) do
    {:noreply, assign(socket, :current_section, value)}
  end

  @impl true
  def handle_event("load-more", _, %{assigns: _assigns} = socket) do
    {:noreply, socket}
  end
end
