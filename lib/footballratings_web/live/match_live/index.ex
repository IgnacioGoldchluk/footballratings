defmodule FootballratingsWeb.MatchLive.Index do
  use FootballratingsWeb, :live_view
  alias FootballratingsWeb.MatchLive.Search
  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">Search matches</.header>

      <.simple_form for={@form} id="search_matches" phx-submit="search" phx-change="validate">
        <.input
          field={@form[:home_team]}
          type="text"
          label="Home Team"
          phx-debounce="blur"
          class="rounded-lg w-full max-w-xs"
        />
        <.input
          field={@form[:away_team]}
          type="text"
          label="Away Team"
          phx-debounce="blur"
          class="rounded-lg w-full max-w-xs"
        />
        <.input field={@form[:before]} type="text" label="Before (YYYY-MM-AA)" phx-debounce="blur" />
        <.input field={@form[:after]} type="text" label="After (YYYY-MM-AA)" phx-debounce="blur" />
        <.input
          field={@form[:available_for_rating]}
          type="checkbox"
          label="Available for rating only"
          class="checkbox"
        />

        <:actions>
          <.button class="btn-primary disabled:bg-zinc-200" disabled={@form.errors != []}>
            Search matches
          </.button>
        </:actions>
      </.simple_form>
      <div class="py-2">
        <.button class="btn-primary disabled:bg-zinc-200" phx-click="all_available_matches">
          All available matches
        </.button>
      </div>
      <div class="py-2">
        <.button class="btn-primary disabled:bg-zinc-200" phx-click="clear">
          Clear
        </.button>
      </div>
      <%= for match <- @matches do %>
        <.match match={match} />
      <% end %>
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
      |> assign(:matches, [])
    }
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
    {:noreply, assign(socket, :matches, FootballInfo.matches_for_search_params(search_params))}
  end

  @impl true
  def handle_event("all_available_matches", _, socket) do
    {:noreply, assign(socket, :matches, FootballInfo.matches_available_for_rating())}
  end

  @impl true
  def handle_event("clear", _, socket) do
    {:noreply, assign(socket, :matches, [])}
  end

  def match(assigns) do
    ~H"""
    <h2 class="font-semibold"><%= @match.league.name %> - <%= @match.round %></h2>
    <div class="join-vertical">
      <.team
        team={@match.home_team}
        goals={@match.goals_home}
        penalties={@match.penalties_home}
        match_id={@match.id}
      />
      <.team
        team={@match.away_team}
        goals={@match.goals_away}
        penalties={@match.penalties_away}
        match_id={@match.id}
      />
    </div>
    """
  end

  def team(assigns) do
    ~H"""
    <div class="grid w-min bg-white border-solid border-2 border-primary join-item rounded-lg">
      <div class="flex justify-between flex-auto">
        <img src={"https://media.api-sports.io/football/teams/#{@team.id}.png"} width="50" />
        <p class="w-48 font-semibold pl-4 py-2"><%= @team.name %></p>
        <.result goals={@goals} penalties={@penalties} />
        <.link navigate={"/matches/#{@match_id}/rate/#{@team.id}"} class="py-1 px-1">
          <button class="btn btn-primary">Rate players</button>
        </.link>
      </div>
    </div>
    """
  end

  def result(assigns) do
    ~H"""
    <%= if @penalties != nil do %>
      <p class="font-semibold w-16 py-2"><%= @goals %> (<%= @penalties %>)</p>
    <% else %>
      <p class="font-semibold w-16 py-2"><%= @goals %></p>
    <% end %>
    """
  end
end
