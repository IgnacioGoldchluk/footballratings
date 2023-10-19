defmodule FootballratingsWeb.MatchLive.Rate do
  use FootballratingsWeb, :live_view

  @initial_score "5"

  alias Footballratings.{Ratings, Accounts}
  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <%= if @match.status != :ready do %>
      <div class="flex flex-col items-center gap-2">
        <div class="text-xl text-error">This match is no longer available for rating</div>
        <.link patch={~p"/matches/#{@match.id}"}>
          <.button class="btn btn-primary" id="back-to-match-button">Back to match</.button>
        </.link>
      </div>
    <% else %>
      <div class="flex flex-col gap-2 items-center">
        <.link patch={~p"/matches/#{@match.id}"}>
          <.button class="btn btn-primary" id="back-to-match-button">Back to match</.button>
        </.link>
        <.form for={@scores} id="scores" phx-submit="submit">
          <div class="grid gap-4 grid-cols-none">
            <%= for player <- @players do %>
              <.player_to_rate player={player} score={@scores[player.id]} />
            <% end %>
          </div>
          <div class="flex py-2 justify-center">
            <.button
              class="btn btn-primary btn-wide"
              phx-disable-with="Saving..."
              id="rate-players-button"
            >
              Rate players
            </.button>
          </div>
        </.form>
      </div>
    <% end %>
    """
  end

  @impl true
  def mount(%{"match_id" => match_id, "team_id" => team_id}, %{"users_token" => token}, socket) do
    [match_id, team_id] = [match_id, team_id] |> Enum.map(&String.to_integer/1)

    user = Accounts.get_users_by_session_token(token)

    case Ratings.match_ratings_id(match_id, team_id, user.id) do
      nil -> {:ok, socket |> assign_information_to_rate(match_id, team_id)}
      match_ratings_id -> {:ok, socket |> redirect_to_existing_ratings(match_ratings_id)}
    end
  end

  defp assign_information_to_rate(socket, match_id, team_id) do
    players = FootballInfo.players_for_match(match_id, team_id)

    socket
    |> assign(:players, players)
    |> assign(:scores, Map.new(players, fn %{id: id} -> {id, @initial_score} end))
    |> assign(:team_id, team_id)
    |> assign(:match, FootballInfo.get_match(match_id))
  end

  defp redirect_to_existing_ratings(socket, match_ratings_id) do
    socket
    |> put_flash(:error, "You already voted for this match")
    |> redirect(to: ~p"/ratings/show/#{match_ratings_id}")
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
        %{assigns: %{players: players, team_id: team_id, match: %{id: match_id}}} = socket
      ) do
    users_id = socket.assigns.current_users.id

    {:ok, match_ratings} =
      Ratings.create_match_and_players_ratings(players, scores, team_id, match_id, users_id)

    Footballratings.Notifiers.Rating.broadcast_new_rating(match_ratings)

    {:noreply, push_navigate(socket, to: ~p"/ratings/show/#{match_ratings.id}")}
  end

  def player_to_rate(assigns) do
    ~H"""
    <div class="grid grid-cols-2 justify-around bg-secondary border-2 border-primary rounded-lg w-96 px-4 py1-">
      <FootballratingsWeb.PlayerComponents.player_rating_box player={@player} score={@score} />
      <.rating_bar player={@player} score={@score} />
    </div>
    """
  end

  def rating_bar(assigns) do
    ~H"""
    <div class="flex px-1 py-1">
      <.score_input value={"#{@score}"} name={@player.id} field={@player.id} />
    </div>
    """
  end
end
