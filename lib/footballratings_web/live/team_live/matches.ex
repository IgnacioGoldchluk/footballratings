defmodule FootballratingsWeb.TeamLive.Matches do
  use FootballratingsWeb, :live_view
  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <.link href={~p"/teams/#{@team.id}"}>
      <.button class="btn btn-primary">Back to team</.button>
    </.link>
    <FootballratingsWeb.MatchComponents.matches_table matches={@streams.matches} />
    """
  end

  @impl true
  def mount(%{"team_id" => team_id}, _session, socket) do
    {:ok,
     socket
     |> assign_team(team_id)
     |> stream_configure(:matches, dom_id: &"matches-(#{&1.id})")
     |> assign_matches(team_id)}
  end

  defp assign_team(socket, team_id) do
    assign(socket, :team, team_id |> String.to_integer() |> FootballInfo.get_team())
  end

  defp assign_matches(socket, team_id) do
    stream(
      socket,
      :matches,
      team_id |> String.to_integer() |> FootballInfo.matches_for_team() |> IO.inspect()
    )
  end

  @impl true
  def handle_event("load-more", _, socket) do
    {:noreply, socket}
  end
end
