defmodule FootballratingsWeb.RatingLive.MatchStatistics do
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings
  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <div>Total ratings: <%= @number_of_ratings %></div>
    <FootballratingsWeb.MatchComponents.match_result match={@match} />

    <table class="table table-zebra">
      <thead>
        <tr>
          <th>Player</th>
          <th>Average score</th>
        </tr>
      </thead>
      <tbody>
        <%= for player <- @players do %>
          <tr>
            <td>
              <.link navigate={~p"/players/#{player.id}"} class="hover:text-primary">
                <%= player.name %>
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

    players =
      players_matches
      |> Enum.map(fn %{team_id: team_id, player: player} -> %{player | team_id: team_id} end)

    {:ok,
     socket
     |> assign(:match, match)
     |> assign(:number_of_ratings, number_of_ratings)
     |> assign(:players, players)
     |> assign(:average_ratings, average_ratings)}
  end
end
