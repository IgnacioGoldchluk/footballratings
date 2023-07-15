defmodule FootballratingsWeb.TeamLive.Matches do
  use FootballratingsWeb, :live_view
  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <.link patch={~p"/teams/#{@team.id}"}>
      <.button class="btn btn-primary">Back to team</.button>
    </.link>
    <FootballratingsWeb.MatchComponents.matches_table matches={@streams.matches} page={@page} />
    """
  end

  @impl true
  def mount(%{"team_id" => team_id}, _session, socket) do
    team_id_as_int = String.to_integer(team_id)

    {:ok,
     socket
     |> assign_team(team_id_as_int)
     |> stream_configure(:matches, dom_id: &"matches-(#{&1.id})")
     |> assign_page()
     |> assign_matches()}
  end

  defp assign_team(socket, team_id) do
    assign(socket, :team, team_id |> FootballInfo.get_team())
  end

  defp assign_matches(%{assigns: %{page: %{entries: entries}}} = socket) do
    stream(socket, :matches, entries)
  end

  defp assign_page(
         %{assigns: %{page: %{page_number: page_number}, team: %{id: team_id}}} = socket
       ) do
    assign(socket, :page, FootballInfo.paginated_matches_for_team(team_id, page_number + 1))
  end

  defp assign_page(%{assigns: %{team: %{id: team_id}}} = socket) do
    assign(socket, :page, FootballInfo.paginated_matches_for_team(team_id))
  end

  @impl true
  def handle_event("load-more", _, socket) do
    {:noreply, socket |> assign_page() |> assign_matches()}
  end
end
