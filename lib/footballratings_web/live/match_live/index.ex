defmodule FootballratingsWeb.MatchLive.Index do
  use FootballratingsWeb, :live_view
  alias FootballratingsWeb.MatchLive.Search
  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm items-center">
      <div class="flex flex-col gap-2">
        <.simple_form for={@form} id="search_matches" phx-submit="search" phx-change="validate">
          <.input
            field={@form[:home_team]}
            type="text"
            label="Home Team"
            phx-debounce="blur"
            class="rounded-lg w-full max-w-max"
          />
          <.input
            field={@form[:away_team]}
            type="text"
            label="Away Team"
            phx-debounce="blur"
            class="rounded-lg w-full max-w-max"
          />
          <.input
            field={@form[:before]}
            type="text"
            label="Before (YYYY-MM-AA)"
            phx-debounce="blur"
            class="rounded-lg max-w-xs"
          />
          <.input
            field={@form[:after]}
            type="text"
            label="After (YYYY-MM-AA)"
            phx-debounce="blur"
            class="rounded-lg"
          />
          <.input field={@form[:league]} type="select" label="League" options={@leagues} />
          <.input
            field={@form[:available_for_rating]}
            type="checkbox"
            label="Available for rating only"
            class="checkbox"
          />
          <:actions>
            <.button class="btn-primary disabled:bg-zinc-200 w-20" disabled={@form.errors != []}>
              Search
            </.button>
          </:actions>
        </.simple_form>
      </div>
      <div class="flex flex-col py-2 gap-2">
        <.button class="btn-primary disabled:bg-zinc-200 w-20" phx-click="clear">
          Clear
        </.button>
      </div>
      <div id="#search-table"></div>
      <FootballratingsWeb.MatchComponents.matches_table matches={@streams.matches} id="#search-table" />
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Search.changeset(%Search{}, %{})

    {
      :ok,
      socket
      |> assign_form(changeset)
      |> stream_configure(:matches, dom_id: &"matches-#{&1.id}")
      |> stream(:matches, [])
      |> assign_leagues()
    }
  end

  defp assign_leagues(socket) do
    leagues = FootballInfo.get_all_leagues() |> Enum.map(fn %{name: name} -> name end)

    assign(socket, :leagues, leagues)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "search")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  @impl true
  def handle_event("validate", %{"search" => search_params}, socket) do
    changeset = Search.changeset(%Search{}, search_params)

    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  @impl true
  def handle_event("search", %{"search" => search_params}, socket) do
    socket =
      socket
      |> stream(:matches, FootballInfo.matches_for_search_params(search_params))
      |> push_event("scroll", %{value: "#search-table"})

    {:noreply, socket}
  end

  @impl true
  def handle_event("clear", _, socket) do
    {:noreply, stream(socket, :matches, [], reset: true)}
  end

  @impl true
  def handle_event("load-more", _, %{assigns: _assigns} = socket) do
    {:noreply, socket}
  end
end
