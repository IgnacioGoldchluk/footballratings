defmodule FootballratingsWeb.RatingLive.Show do
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid justify-items-center gap-4">
    <div class="flex space-x-1">
    <div>By</div>
    <.link href={~p"/ratings/users/#{@user.id}"}>
    <div class="hover:text-primary"><%= @user.username %></div>
    </.link>
    <div>on</div>
    <div><%= @inserted_at %></div>
    </div>
    <FootballratingsWeb.MatchComponents.match_result match={@match} />
    <div class="grid gap-4 grid-cols-3">
    <%= for player_rating <- @player_ratings do %>
    <div class="grid grid-cols-2 justify-around bg-secondary border-2 border-primary rounded-lg w-48 px-4 py-1">
      <FootballratingsWeb.PlayerComponents.player_rating_box player={player_rating.player} score={player_rating.score} />
      </div>
    <% end %>
    </div>
    </div>
    """
  end

  @impl true
  def mount(%{"match_ratings_id" => match_ratings_id}, _session, socket) do
    [%{match: match, user: user, player_ratings: player_ratings, inserted_at: inserted_at}] =
      match_ratings_id
      |> String.to_integer()
      |> Ratings.get_players_ratings()

    {:ok,
     socket
     |> assign(:match, match)
     |> assign(:user, user)
     |> assign(:inserted_at, inserted_at |> NaiveDateTime.to_date())
     |> assign(:player_ratings, player_ratings)}
  end
end
