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
    <FootballratingsWeb.MatchComponents.matches_table matches={@streams.matches} />
    """
  end

  @impl true
  def mount(%{"player_id" => player_id}, _session, socket) do
    statistics = Ratings.player_statistics(player_id |> String.to_integer())

    {
      :ok,
      socket
      |> assign_player(player_id)
      |> assign_player_statistics_svg(statistics)
      |> assign_teams(statistics)
      |> assign_current_team()
      |> assign_matches_for_player(player_id)
    }
  end

  @impl true
  def handle_event("load-more", _, socket) do
    {:noreply, socket}
  end

  defp assign_matches_for_player(socket, player_id) do
    socket
    |> stream_configure(:matches, dom_id: &"matches-#{&1.id}")
    |> stream(:matches, player_id |> String.to_integer() |> FootballInfo.matches_for_player())
  end

  defp assign_player(socket, player_id) do
    assign(socket, :player, FootballInfo.get_player(player_id |> String.to_integer()))
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
end
