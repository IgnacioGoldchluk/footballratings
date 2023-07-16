defmodule FootballratingsWeb.TeamLive.Index do
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo
  alias FootballratingsWeb.TeamLive.Search

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">Search team</.header>

      <.simple_form for={@form} id="search_team" phx-change="search" phx-throttle="300">
        <.input field={@form[:name]} type="text" label="Team name" class="rounded-lg w-full max-w-xs" />
      </.simple_form>

      <.table
        id="teams"
        rows={@streams.teams}
        row_click={fn {_id, team_id} -> JS.navigate(~p"/teams/#{team_id}") end}
      >
        <:col :let={{_id, team}} label="Team"><%= team.name %></:col>
      </.table>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Search.changeset(%Search{}, %{})

    socket =
      socket
      |> assign_form(changeset)
      |> stream(:teams, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"search" => search_params}, socket) do
    changeset = Search.changeset(%Search{}, search_params)

    socket =
      socket
      |> assign_form(Map.put(changeset, :action, :validate))
      |> maybe_assign_teams(changeset, search_params)

    {:noreply, socket}
  end

  defp maybe_assign_teams(socket, changeset, search_params) do
    if changeset.valid? do
      stream(socket, :teams, FootballInfo.teams_for_search_params(search_params), reset: true)
    else
      stream(socket, :teams, [], reset: true)
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "search")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
