defmodule FootballratingsWeb.RatingLive.MatchStatistics do
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings
  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <.link navigate={~p"/matches/#{@match.id}"}>
      <.button class="btn btn-primary">
        Back to match
      </.button>
    </.link>
    <div>Total ratings: <%= @number_of_ratings %></div>
    <.button phx-click="team_selected" phx-value-team={@match.home_team.name}>
      <FootballratingsWeb.MatchComponents.team
        team={@match.home_team}
        goals={@match.goals_home}
        penalties={@match.penalties_home}
        match_id={@match.id}
      />
    </.button>
    <.button phx-click="team_selected" phx-value-team={@match.away_team.name}>
      <FootballratingsWeb.MatchComponents.team
        team={@match.away_team}
        goals={@match.goals_away}
        penalties={@match.penalties_away}
        match_id={@match.id}
      />
    </.button>
    <table class="table table-zebra" id="the-table" hidden>
      <thead>
        <tr>
          <th>Player</th>
          <th>Team</th>
          <th>Average score</th>
        </tr>
      </thead>
      <tbody>
        <%= for %{player: player, team: team} <- players_matches_for_team(@players_matches, @team_name) do %>
          <tr>
            <td>
              <FootballratingsWeb.PlayerComponents.player_link id={player.id} name={player.name} />
            </td>
            <td>
              <.link navigate={~p"/teams/#{team.id}"} class="hover:text-primary">
                <%= team.name %>
              </.link>
            </td>
            <td><%= Map.get(@average_ratings, player.id, "No ratings yet") %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
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
