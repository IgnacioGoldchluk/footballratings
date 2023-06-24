defmodule FootballratingsWeb.RatingLive.PlayerStatistics do
  alias FootballratingsWeb.PlayerRatingsTimeseries
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings

  def render(assigns) do
    ~H"""
    <div id="player-stats-chart"><%= @ratings_svg %></div>
    """
  end

  def mount(_params, _session, socket) do
    # player_statistics =
    #   player_id
    #   |> String.to_integer()
    #   |> Ratings.player_statistics()
    {:ok, socket |> assign_chart()}

    # {:ok, assign(socket, :player_statistics, player_statistics)}
  end

  def assign_chart(socket) do
    assign(socket, :ratings_svg, random_data() |> PlayerRatingsTimeseries.plot())
  end

  def random_data() do
    today = DateTime.utc_now() |> DateTime.to_unix()
    day = 24 * 60 * 60

    [
      %{average: 6.0, timestamp: today, team: "Lanus"},
      %{average: 7.5, timestamp: today + 7 * day, team: "Lanus"},
      %{average: 5.0, timestamp: today + 10 * day, team: "Lanus"},
      %{average: 4.0, timestamp: today + 20 * day, team: "Boca"},
      %{average: 3.0, timestamp: today + 27 * day, team: "Boca"},
      %{average: 7.0, timestamp: today + 30 * day, team: "Boca"}
    ]
  end
end
