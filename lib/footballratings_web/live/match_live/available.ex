defmodule FootballratingsWeb.MatchLive.Available do
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <div class="text-l">Click on a team to rate the players</div>
    <FootballratingsWeb.MatchComponents.matches_table matches={@streams.matches} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream_configure(:matches, dom_id: &"matches-(#{&1.id})")
     |> assign_available_matches()}

    {:ok, assign_available_matches(socket)}
  end

  defp assign_available_matches(socket) do
    stream(socket, :matches, FootballInfo.matches_available_for_rating())
  end

  @impl true
  def handle_event("load-more", _, %{assigns: _assigns} = socket) do
    {:noreply, socket}
  end
end
