defmodule FootballratingsWeb.TeamLive.Players do
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo
  alias FootballratingsWeb.PlayerLive.Search

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-2">
    <.link patch={~p"/teams/#{@team_with_players.id}"}>
      <.button class="btn btn-primary">Back to team</.button>
    </.link>
    <.simple_form for={@form} id="search_player" phx-change="search_player" phx-throttle="300">
      <.input field={@form[:name]} type="text" label="Filter by name" class="rounded-lg w-full max-w-xs" />
    </.simple_form>
    <.table
      id="players"
      rows={@team_with_players.players |> Enum.filter(fn %{name: name} -> is_player_name_substring?(name, @search_players) end)}
      row_click={fn %{id: player_id} -> JS.navigate(~p"/players/#{player_id}") end}
    >
      <:col :let={player} label="Name"><%= player.name %></:col>
    </.table>
    </div>
    """
  end

  @impl true
  def mount(%{"team_id" => team_id}, _session, socket) do
    changeset = Search.changeset(%Search{}, %{})

    {:ok,
     socket
     |> assign_team_with_players(team_id)
     |> assign_form(changeset)
     |> assign_search_players("")}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset, as: "search"))
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
  def handle_event("search_player", %{"search" => %{"name" => name} = search_params}, socket) do
    changeset = Search.changeset(%Search{}, search_params)

    socket =
      socket
      |> assign_form(changeset)
      |> assign_search_players(name)

    {:noreply, socket}
  end

  defp is_player_name_substring?(player_name, substring) do
    player_name |> String.downcase() |> String.contains?(String.downcase(substring))
  end
end
