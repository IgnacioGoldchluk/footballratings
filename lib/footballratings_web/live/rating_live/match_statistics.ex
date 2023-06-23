defmodule FootballratingsWeb.RatingLive.MatchStatistics do
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings
  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <div>Total ratings: <%= @number_of_ratings %></div>
    <FootballratingsWeb.MatchComponents.match_result match={@match} />
    <ul>
    <%= for player <- @players do %>
      <li><%= player.name %> - <%= Map.get(@average_ratings, player.id, "Not rated yet") %></li>
    <% end %>
    </ul>
    """
  end

  @impl true
  def mount(%{"match_id" => match_id}, _session, socket) do
    match_id_int = String.to_integer(match_id)
    %{players: players} = match = FootballInfo.players_for_match(match_id_int)
    number_of_ratings = Ratings.number_of_match_ratings(match_id_int)
    average_ratings = Ratings.average_player_ratings(match_id)

    IO.inspect(average_ratings)

    {:ok,
     socket
     |> assign(:match, match)
     |> assign(:number_of_ratings, number_of_ratings)
     |> assign(:players, players)
     |> assign(:average_ratings, average_ratings)}
  end
end
