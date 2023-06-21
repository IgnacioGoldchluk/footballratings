defmodule FootballratingsWeb.MatchLive.Rate do
  use FootballratingsWeb, :live_view

  @initial_score "5"

  alias Footballratings.Ratings

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

  def player_to_rate(assigns) do
    ~H"""
    <div class="grid grid-cols-2 justify-around bg-secondary border-2 border-primary rounded-lg w-96 px-4">
    <div class="flex flex-col justify-items-start px-2">
        <FootballratingsWeb.PlayerComponents.player name={@player.name} id={@player.id} />
    </div>
    <div class="flex items-center pl-10">
        <FootballratingsWeb.PlayerComponents.score score={@score} />
    </div>
    <div class="flex px-1 py-1">
        <.score_input
            value={"#{@score}"}
            name={@player.id}
            field={@player.id}
        />
    </div>
    </div>
    """
  end
end
