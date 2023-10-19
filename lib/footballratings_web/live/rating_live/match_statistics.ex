defmodule FootballratingsWeb.RatingLive.MatchStatistics do
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings
  alias Footballratings.FootballInfo
  alias Phoenix.PubSub

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-2 items-center">
      <.link patch={~p"/matches/#{@match_with_players.id}"} id="back-to-match-button">
        <.button class="btn btn-primary">
          Back to match
        </.button>
      </.link>
      <div>Total ratings for this match: <%= @number_of_ratings %></div>
      <.button
        phx-click="team_selected"
        phx-value-team={@match_with_players.home_team.name}
        id="home-team-stats"
      >
        <FootballratingsWeb.MatchComponents.team
          team={@match_with_players.home_team}
          goals={@match_with_players.goals_home}
          penalties={@match_with_players.penalties_home}
          pinned={@match_with_players.home_team.name == @team_name}
        />
      </.button>
      <.button
        phx-click="team_selected"
        phx-value-team={@match_with_players.away_team.name}
        id="away-team-stats"
      >
        <FootballratingsWeb.MatchComponents.team
          team={@match_with_players.away_team}
          goals={@match_with_players.goals_away}
          penalties={@match_with_players.penalties_away}
          pinned={@match_with_players.away_team.name == @team_name}
        />
      </.button>
    </div>
    <.table
      id="players-statistics"
      rows={players_matches_for_team(@match_with_players.players_matches, @team_name)}
      row_click={fn %{player: player} -> JS.navigate(~p"/players/#{player.id}") end}
    >
      <:col :let={player_match} label="Name"><%= player_match.player.name %></:col>
      <:col :let={player_match} label="Average score">
        <%= Map.get(@average_ratings, player_match.player.id, "No ratings yet") %>
      </:col>
    </.table>
    """
  end

  @impl true
  def mount(%{"match_id" => match_id}, _session, socket) do
    match_id_int = String.to_integer(match_id)

    PubSub.subscribe(Footballratings.PubSub, "match:#{match_id_int}")

    {:ok,
     socket
     |> assign_match_with_players(match_id_int)
     |> assign_number_of_ratings()
     |> assign_average_ratings()
     |> assign_teams()}
  end

  @impl true
  def handle_event("team_selected", %{"team" => team_name}, socket) do
    {:noreply, assign(socket, :team_name, team_name)}
  end

  @impl true
  def handle_info(%{"type" => "new_rating"}, socket) do
    {:noreply,
     socket
     |> assign_number_of_ratings()
     |> assign_average_ratings()}
  end

  defp players_matches_for_team(players_matches, selected_team_name) do
    players_matches
    |> Enum.filter(fn %{team: %{name: team_name}} -> team_name == selected_team_name end)
  end

  defp assign_average_ratings(%{assigns: %{match_with_players: %{id: mid}}} = socket) do
    assign(socket, :average_ratings, Ratings.average_player_ratings(mid))
  end

  defp assign_teams(%{assigns: %{match_with_players: %{players_matches: pm}}} = socket) do
    teams = for %{team: %{name: n}} <- pm, do: n, into: MapSet.new()

    socket
    |> assign(:teams, teams)
    |> assign(:team_name, Enum.at(teams, 0))
  end

  defp assign_number_of_ratings(%{assigns: %{match_with_players: %{id: mid}}} = socket) do
    assign(socket, :number_of_ratings, Ratings.number_of_match_ratings(mid))
  end

  defp assign_match_with_players(socket, match_id) do
    assign(socket, :match_with_players, FootballInfo.players_for_match(match_id))
  end
end
