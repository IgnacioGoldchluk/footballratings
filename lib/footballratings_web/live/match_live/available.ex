defmodule FootballratingsWeb.MatchLive.Available do
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <div class="text-l">Click on a team to rate the players</div>
    <FootballratingsWeb.MatchComponents.matches_table matches={@available_matches} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_available_matches(socket)}
  end

  defp assign_available_matches(socket) do
    assign(socket, :available_matches, FootballInfo.matches_available_for_rating())
  end
end
