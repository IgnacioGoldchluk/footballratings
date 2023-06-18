defmodule FootballratingsWeb.MatchLive.Rate do
  use FootballratingsWeb, :live_view

  @initial_score "5"

  @impl true
  def render(assigns) do
    ~H"""
    <.form for={@scores} phx-submit="submit">
      <%= for player <- @players do %>
        <%= player.name %>: <%= @scores[player.id] %>
        <.input
          type="range"
          min="1"
          max="10"
          value={"#{@scores[player.id]}"}
          step="1"
          class="range range-primary w-auto"
          name={player.id}
          field={player.id}
          phx-change="player_changed"
        />
      <% end %>
      <.button class="btn btn-primary" phx-disable-with="Saving...">Rate players</.button>
    </.form>
    <.link navigate={~p"/matches"}>
      <.button class="btn btn-primary">Back to matches</.button>
    </.link>
    """
  end

  @impl true
  def mount(%{"match_id" => match_id, "team_id" => team_id}, _session, socket) do
    {match_id, team_id} = {String.to_integer(match_id), String.to_integer(team_id)}
    players = Footballratings.FootballInfo.players_for_match(match_id, team_id)

    scores = Map.new(players, fn %{id: id} -> {id, @initial_score} end)

    {:ok,
     socket
     |> assign(:players, players)
     |> assign(:scores, scores)}
  end

  @impl true
  def handle_event(
        "player_changed",
        %{"_target" => [player_id]} = changes,
        %{assigns: %{scores: scores}} = socket
      ) do
    id_as_int = String.to_integer(player_id)
    scores = Map.put(scores, id_as_int, Map.get(changes, player_id))

    {:noreply, assign(socket, :scores, scores)}
  end

  @impl true
  def handle_event("save", scores, socket) do
    # TODO: Save scores
    # push_naviate()
  end
end
