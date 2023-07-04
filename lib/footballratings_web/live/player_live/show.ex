defmodule FootballratingsWeb.PlayerLive.Show do
  alias FootballratingsWeb.PlayerRatingsTimeseries
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo
  alias Footballratings.Ratings

  @impl true
  def render(assigns) do
    ~H"""
    <FootballratingsWeb.PlayerComponents.player name={@player.name} id={@player.id} />
    <div>
      <.form :let={_f} for={%{}} as={:team_filter} phx-change="select_team" id="team-selector">
        <.input
          type="select"
          name="team"
          id="select-team"
          options={["All" | @teams]}
          value={@current_team}
          phx-value-team={@current_team}
        />
      </.form>
    </div>
    <div id="player-stats-chart"><%= @player_statistics_svg %></div>
    <FootballratingsWeb.MatchComponents.matches_table matches={@matches_for_player} />
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
  def handle_event("select_team", %{"team" => team}, %{assigns: %{player: player}} = socket) do
    %{id: player_id} = player

    statistics =
      case team do
        "All" -> Ratings.player_statistics(player_id)
        team_name -> Ratings.player_statistics(player_id, team_name)
      end

    {:noreply, assign_player_statistics_svg(socket, statistics)}
  end

  defp assign_matches_for_player(socket, player_id) do
    assign(
      socket,
      :matches_for_player,
      player_id
      |> String.to_integer()
      |> FootballInfo.matches_for_player()
    )
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
