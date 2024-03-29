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
            <.button
              class="btn-primary disabled:bg-zinc-200 w-20"
              disabled={@form.errors != []}
              id="search-button"
              name="search-button"
            >
              Search
            </.button>
          </:actions>
        </.simple_form>
      </div>
      <div class="flex flex-col py-2 gap-2">
        <.button class="btn-primary disabled:bg-zinc-200 w-20" phx-click="clear" id="clear-button">
          Clear
        </.button>
      </div>
      <div id="#search-table"></div>
    </div>
    <%= if @page do %>
      <FootballratingsWeb.MatchComponents.matches_table matches={@streams.matches} page={@page} />
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Search.changeset(%Search{}, %{})

    {
      :ok,
      socket
      |> assign_form(changeset)
      # Temporary assign page to nil since the search is not real time
      |> assign(:page, nil)
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
      |> reset_page(search_params)
      |> reset_matches()
      |> push_event("scroll", %{value: "#search-table"})

    {:noreply, socket}
  end

  @impl true
  def handle_event("clear", _, socket) do
    {:noreply, stream(socket, :matches, [], reset: true) |> assign(:page, nil)}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    {:noreply, socket |> assign_page() |> assign_matches()}
  end

  defp reset_page(socket, search_params) do
    socket
    # Saving it to re-query
    |> assign(:search_params, search_params)
    |> assign(:page, FootballInfo.paginated_matches_for_search_params(search_params))
  end

  defp reset_matches(%{assigns: %{page: %{entries: entries}}} = socket) do
    stream(socket, :matches, entries, reset: true)
  end

  defp assign_page(
         %{assigns: %{page: %{page_number: page_number}, search_params: search_params}} = socket
       ) do
    assign(
      socket,
      :page,
      FootballInfo.paginated_matches_for_search_params(search_params, page_number + 1)
    )
  end

  defp assign_matches(%{assigns: %{page: %{entries: entries}}} = socket) do
    stream(socket, :matches, entries)
  end
end
