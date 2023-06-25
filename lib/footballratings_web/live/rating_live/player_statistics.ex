defmodule FootballratingsWeb.RatingLive.PlayerStatistics do
  alias FootballratingsWeb.PlayerRatingsTimeseries
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings

  def render(assigns) do
    ~H"""
    <div id="player-stats-chart"><%= @chart_svg %></div>
    """
  end

  def mount(%{"player_id" => player_id}, _session, socket) do
    player_statistics =
      player_id
      |> String.to_integer()
      |> Ratings.player_statistics()

    {:ok, socket |> assign_chart_svg(player_statistics)}
  end

  def assign_chart_svg(socket, player_statistics) do
    assign(socket, :chart_svg, PlayerRatingsTimeseries.plot(player_statistics))
  end
end
