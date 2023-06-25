defmodule FootballratingsWeb.RatingLive.PlayerStatistics do
  alias FootballratingsWeb.PlayerRatingsTimeseries
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings
  alias Footballratings.FootballInfo

  def render(assigns) do
    ~H"""
    <div id="player-stats-chart"><%= @chart_svg %></div>
    """
  end

  def mount(%{"player_id" => player_id}, _session, socket) do
    player_id_as_int = String.to_integer(player_id)

    player_statistics = Ratings.player_statistics(player_id_as_int)
    %{teams: teams} = FootballInfo.teams_a_player_has_played_for(player_id_as_int)

    {:ok, socket |> assign_chart_svg(player_statistics) |> assign(:teams, teams)}
  end

  def assign_chart_svg(socket, player_statistics) do
    assign(socket, :chart_svg, PlayerRatingsTimeseries.plot(player_statistics))
  end
end
