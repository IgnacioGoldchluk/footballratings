defmodule FootballratingsWeb.PlayerLive.Index do
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo
  alias FootballratingsWeb.PlayerLive.Search

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-aut- max-w-sm">
      <.header class="text-center">Search player</.header>

      <.simple_form for={@form} id="search_player" phx-change="search" phx-throttle="300">
        <.input
          field={@form[:name]}
          type="text"
          label="Player name"
          class="rounded-lg w-full max-w-xs"
        />
      </.simple_form>

      <%= if @players != [] do %>
        <table class="table table-zebra">
          <thead>
            <tr>
              <th>Player</th>
              <th>Team</th>
            </tr>
          </thead>
          <tbody>
            <%= for player <- @players do %>
                <tr>
                <td><%= player.name %></td>
                <td><.link href={~p"/teams/#{player.team.id}"} class="hover:text-primary"><%= player.team.name %></.link></td>
                </tr>
            <% end %>
            </tbody>
          </table>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Search.changeset(%Search{}, %{})

    {:ok, socket |> assign_form(changeset) |> assign(:players, [])}
  end

  @impl true
  def handle_event("search", %{"search" => search_params}, socket) do
    changeset = Search.changeset(%Search{}, search_params)

    socket =
      socket
      |> assign_form(Map.put(changeset, :action, :validate))
      |> maybe_assign_players(changeset, search_params)

    {:noreply, socket}
  end

  defp maybe_assign_players(socket, changeset, search_params) do
    if changeset.valid? do
      assign(socket, :players, FootballInfo.players_for_search_params(search_params))
    else
      assign(socket, :players, [])
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
