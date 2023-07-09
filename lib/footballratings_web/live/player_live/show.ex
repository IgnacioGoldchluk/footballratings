defmodule FootballratingsWeb.PlayerLive.Show do
  alias FootballratingsWeb.PlayerRatingsTimeseries
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo
  alias Footballratings.Ratings

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center gap-1">
      <FootballratingsWeb.PlayerComponents.player name={@player.name} id={@player.id} />
    </div>
    <div id="player-stats-chart"><%= @player_statistics_svg %></div>
    <FootballratingsWeb.MatchComponents.matches_table matches={@streams.matches} page={@page} />
    """
  end

  @impl true
  def mount(%{"player_id" => player_id}, _session, socket) do
    player_id_as_int = String.to_integer(player_id)
    statistics = Ratings.player_statistics(player_id_as_int)

    {
      :ok,
      socket
      |> assign_player(player_id_as_int)
      |> assign_player_statistics_svg(statistics)
      |> assign_teams(statistics)
      |> assign_current_team()
      |> assign_page()
      |> assign_matches()
    }
  end

  @impl true
  def handle_event("load-more", _, socket) do
    {:noreply, socket |> assign_page() |> assign_matches()}
  end

  defp assign_player(socket, player_id) do
    assign(socket, :player, FootballInfo.get_player(player_id))
  end

  defp assign_current_team(socket, current_team \\ "All") do
    assign(socket, :current_team, current_team)
  end

  defp assign_teams(socket, player_statistics) do
    teams = player_statistics |> Enum.map(fn %{team: team} = _stats -> team end)
    assign(socket, :teams, teams)
  end

  defp assign_player_statistics_svg(socket, []) do
    assign(socket, :player_statistics_svg, "")
  end

  defp assign_player_statistics_svg(socket, player_statistics) do
    assign(socket, :player_statistics_svg, PlayerRatingsTimeseries.plot(player_statistics))
  end

  defp assign_page(
         %{assigns: %{page: %{page_number: page_number}, player: %{id: player_id}}} = socket
       ) do
    page = player_id |> FootballInfo.paginated_matches_for_player(page_number + 1)

    assign(socket, :page, page)
  end

  defp assign_page(%{assigns: %{player: %{id: player_id}}} = socket) do
    assign(
      socket,
      :page,
      FootballInfo.paginated_matches_for_player(player_id)
    )
  end

  defp assign_matches(%{assigns: %{page: %{entries: entries}}} = socket) do
    stream(socket, :matches, entries)
  end
end
