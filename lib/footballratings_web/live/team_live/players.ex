defmodule FootballratingsWeb.TeamLive.Players do
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo
  alias FootballratingsWeb.PlayerLive.Search

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-2">
    <.link navigate={~p"/teams/#{@team_with_players.id}"}>
      <.button class="btn btn-primary">Back to team</.button>
    </.link>
    <div class="text-l">Enter player name</div>
    <.form :let={f} id="search" phx-change="search_players">
      <.input field={f[:name]} type="text" class="rounded-lg w-full max-w-xs" />
    </.form>
    <.table
      id="players"
      rows={@team_with_players.players |> Enum.filter(fn %{name: name} = player -> is_player_name_substring?(name, @search_players) end)}
      row_click={fn %{id: player_id} -> JS.navigate(~p"/players/#{player_id}") end}
    >
      <:col :let={player} label="Name"><%= player.name %></:col>
    </.table>
    </div>
    """
  end

  @impl true
  def mount(%{"team_id" => team_id}, _session, socket) do
    {:ok,
     socket
     |> assign_team_with_players(team_id)
     |> assign_search_players("")}
  end

  defp assign_search_players(socket, value) do
    assign(socket, :search_players, value)
  end

  defp assign_team_with_players(socket, team_id) do
    team_with_players =
      team_id
      |> String.to_integer()
      |> FootballInfo.team_with_players()

    assign(socket, :team_with_players, team_with_players)
  end

  @impl true
  def handle_event("search_players", %{"name" => name}, socket) do
    {:noreply, socket |> assign_search_players(name)}
  end

  defp is_player_name_substring?(player_name, substring) do
    player_name |> String.downcase() |> String.contains?(String.downcase(substring))
  end
end
