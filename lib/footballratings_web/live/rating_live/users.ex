defmodule FootballratingsWeb.RatingLive.Users do
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings

  # TODO: Fix this one.

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-center">
      <.table
        id="match_ratings"
        rows={@streams.match_ratings}
        row_click={fn {_id, match_rating_id} -> JS.navigate(~p"/ratings/show/#{match_rating_id}") end}
      >
        <:col :let={{_id, match_rating}} label="League">
          <%= FootballratingsWeb.MatchComponents.acronym(match_rating.match.league.name) %>
        </:col>
        <:col :let={{_id, match_rating}} label="Home Team">
          <div class={infer_text(match_rating.match.home_team.name, match_rating.team.name)}>
            <%= match_rating.match.home_team.name %>
          </div>
        </:col>
        <:col :let={{_id, match_rating}} label="Result">
          <%= FootballratingsWeb.MatchComponents.result_row(match_rating.match) %>
        </:col>
        <:col :let={{_id, match_rating}} label="Away Team">
          <div class={infer_text(match_rating.match.away_team.name, match_rating.team.name)}>
            <%= match_rating.match.away_team.name %>
          </div>
        </:col>
      </.table>
    </div>
    <div id="infinite-scroll-marker" phx-hook="InfiniteScroll"></div>
    """
  end

  @impl true
  def mount(%{"users_id" => users_id}, _session, socket) do
    {:ok,
     socket
     |> stream_configure(:match_ratings, dom_id: &"match-rating-#{&1.id}")
     |> stream(:match_ratings, Ratings.get_ratings_by_user(users_id))}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    {:noreply, socket}
  end

  defp infer_text(team_name, team_name), do: "text-primary"
  defp infer_text(_, _), do: "text"
end
