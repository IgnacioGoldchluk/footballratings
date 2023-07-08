defmodule FootballratingsWeb.RatingLive.MatchStatistics do
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings
  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-2 items-center">
      <.link navigate={~p"/matches/#{@match.id}"}>
        <.button class="btn btn-primary">
          Back to match
        </.button>
      </.link>
      <div>Total ratings for this match: <%= @number_of_ratings %></div>
      <.button phx-click="team_selected" phx-value-team={@match.home_team.name}>
        <FootballratingsWeb.MatchComponents.team
          team={@match.home_team}
          goals={@match.goals_home}
          penalties={@match.penalties_home}
        />
      </.button>
      <.button phx-click="team_selected" phx-value-team={@match.away_team.name}>
        <FootballratingsWeb.MatchComponents.team
          team={@match.away_team}
          goals={@match.goals_away}
          penalties={@match.penalties_away}
        />
      </.button>
    </div>
    <.table
      id="players-statistics"
      rows={players_matches_for_team(@players_matches, @team_name)}
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
    %{players_matches: players_matches} = match = FootballInfo.players_for_match(match_id_int)
    number_of_ratings = Ratings.number_of_match_ratings(match_id_int)
    average_ratings = Ratings.average_player_ratings(match_id)

    teams_names =
      for %{team: %{name: team_name}} <- players_matches, do: team_name, into: MapSet.new()

    {:ok,
     socket
     |> assign(:match, match)
     |> assign(:number_of_ratings, number_of_ratings)
     |> assign(:players_matches, players_matches)
     |> assign(:teams, teams_names)
     # Randomly pick the first team
     |> assign(:team_name, Enum.at(teams_names, 0))
     |> assign(:average_ratings, average_ratings)}
  end

  @impl true
  def handle_event("team_selected", %{"team" => team_name}, socket) do
    {:noreply, assign(socket, :team_name, team_name)}
  end

  defp players_matches_for_team(players_matches, selected_team_name) do
    players_matches
    |> Enum.filter(fn %{team: %{name: team_name}} -> team_name == selected_team_name end)
  end
end
