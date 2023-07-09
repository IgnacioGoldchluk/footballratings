defmodule FootballratingsWeb.MatchLive.Available do
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <FootballratingsWeb.MatchComponents.matches_table matches={@streams.matches} page={@page} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_page()
     |> stream_configure(:matches, dom_id: &"matches-(#{&1.id})")
     |> assign_available_matches()}
  end

  defp assign_page(%{assigns: %{page: %{page_number: page_number}}} = socket) do
    assign(socket, :page, FootballInfo.paginated_matches_available_for_rating(page_number + 1))
  end

  defp assign_page(socket) do
    assign(socket, :page, FootballInfo.paginated_matches_available_for_rating())
  end

  defp assign_available_matches(%{assigns: %{page: %{entries: entries}}} = socket) do
    stream(socket, :matches, entries)
  end

  @impl true
  def handle_event("load-more", _, socket) do
    {:noreply, socket |> assign_page() |> assign_available_matches()}
  end
end
