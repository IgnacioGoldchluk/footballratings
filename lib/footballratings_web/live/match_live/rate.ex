defmodule FootballratingsWeb.MatchLive.Rate do
  use FootballratingsWeb, :live_view

  @initial_score "5"

  alias Footballratings.Ratings

  @impl true
  def render(assigns) do
    ~H"""
    <.link navigate={~p"/matches"}>
      <.button class="btn btn-primary">Back to matches</.button>
    </.link>
    <.form for={@scores} phx-submit="submit">
      <div class="flex flex-col space-y-8">
        <%= for player <- @players do %>
          <div class="flex justify-between w-80">
            <div class="grid grid-rows-2 justify-items-start">
              <img class="mask mask-circle" src="/images/player.jpg" width="75" />
              <div class="text-2xl"><%= player.name %></div>
            </div>
            <div class="flex items-center justify-center rounded-full border-2 bg-primary w-32 object-over h-24 w-16">
              <div class="text-2xl text-black justify-center">
                <%= @scores[player.id] %>
              </div>
            </div>
          </div>
          <.input
            type="range"
            min="1"
            max="10"
            value={"#{@scores[player.id]}"}
            step="1"
            class="range range-primary w-80 duration-300"
            name={player.id}
            field={player.id}
            phx-change="player_changed"
          />
        <% end %>
      </div>
      <.button class="btn btn-primary" phx-disable-with="Saving...">Rate players</.button>
    </.form>
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
     |> assign(:scores, scores)
     |> assign(:team_id, team_id)
     |> assign(:match_id, match_id)}
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
  def handle_event(
        "submit",
        scores,
        %{assigns: %{players: players, team_id: team_id, match_id: match_id}} = socket
      ) do
    user_id = socket.assigns.current_users.id

    {:ok, match_ratings_id} =
      Ratings.create_match_and_players_ratings(players, scores, team_id, match_id, user_id)

    {:noreply, push_navigate(socket, to: ~p"/ratings/#{match_ratings_id}")}
  end
end
