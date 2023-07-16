defmodule FootballratingsWeb.RatingLive.Users do
  use FootballratingsWeb, :live_view

  alias Footballratings.Ratings
  alias Footballratings.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div class="text-l">Ratings by <%= @users.username %></div>
    <.table
      id="match-ratings"
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
      <:col :let={{_id, match_rating}} label="Round">
        <%= match_rating.match.round %>
      </:col>
    </.table>
    <%= if @page.total_pages > @page.page_number do %>
      <.button class="btn btn-primary" phx-click="load-more" id="load-more-matches-ratings-button">
        Load More
      </.button>
    <% end %>
    """
  end

  @impl true
  def mount(%{"users_id" => users_id}, _session, socket) do
    {:ok,
     socket
     |> assign_users(users_id)
     |> assign_page()
     |> assign_match_ratings()}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    {:noreply, socket |> assign_page() |> assign_match_ratings()}
  end

  defp infer_text(team_name, team_name), do: "text-primary"
  defp infer_text(_, _), do: "text"

  defp assign_users(socket, users_id) do
    assign(socket, :users, users_id |> String.to_integer() |> Accounts.get_users!())
  end

  defp assign_page(
         %{assigns: %{page: %{page_number: page_number}, users: %{id: users_id}}} = socket
       ) do
    page = Ratings.paginated_ratings_by_user(users_id, page_number + 1)
    assign(socket, :page, page)
  end

  defp assign_page(%{assigns: %{users: %{id: users_id}}} = socket) do
    assign(socket, :page, Ratings.paginated_ratings_by_user(users_id))
  end

  defp assign_match_ratings(%{assigns: %{page: %{entries: entries}}} = socket) do
    stream(socket, :match_ratings, entries)
  end
end
