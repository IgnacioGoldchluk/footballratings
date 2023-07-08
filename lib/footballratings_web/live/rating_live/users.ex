defmodule FootballratingsWeb.RatingLive.Users do
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings

  # TODO: Fix this one.

  @impl true
  def render(assigns) do
    ~H"""
    <%= for match_rating <- @match_ratings do %>
      <.link navigate={~p"/ratings/show/#{match_rating.id}"}>
        <div class="text-l">For team <%= match_rating.team.name %></div>
        <FootballratingsWeb.MatchComponents.match_result match={match_rating.match} />
      </.link>
    <% end %>
    """
  end

  @impl true
  def mount(%{"users_id" => users_id}, _session, socket) do
    ratings = Ratings.get_ratings_by_user(users_id)
    {:ok, assign(socket, :match_ratings, ratings)}
  end
end
