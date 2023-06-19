defmodule FootballratingsWeb.RatingLive.Show do
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings

  @impl true
  def render(assigns) do
    ~H"""
    <div>For team <%= @team_id %></div>
    <div>By <%= @user_id %></div>
    <%= for player <- @players do %>
      <div><%= player.name %>: <%= player.score %></div>
    <% end %>
    """
  end

  @impl true
  def mount(%{"match_rating_id" => match_rating_id}, _session, socket) do
    %{team: team, user: user, players: players} =
      match_rating_id
      |> String.to_integer()
      |> Ratings.get_players_ratings()

    {:ok,
     socket
     |> assign(:team_id, team[:id])
     |> assign(:user_id, user[:id])
     |> assign(:players, players)}
  end
end
