defmodule FootballratingsWeb.StatsLive do
  use FootballratingsWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="stats stats-vertical lg:stats-horizontal shadow">
      <div class="stat">
        <div class="stat-title">Users</div>
        <div class="stat-value"><%= @users %></div>
        <div class="stat-desc">Total registered users</div>
      </div>

      <div class="stat">
        <div class="stat-title">Matches</div>
        <div class="stat-value"><%= @matches %></div>
        <div class="stat-desc">Matches availables</div>
      </div>

      <div class="stat">
        <div class="stat-title">Ratings</div>
        <div class="stat-value"><%= @ratings %></div>
        <div class="stat-desc">Unique ratings</div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    %{"users" => users, "ratings" => ratings, "matches" => matches} =
      GenServer.call(Footballratings.LiveStats, "live_stats")

    socket =
      socket
      |> assign_users(users)
      |> assign_ratings(ratings)
      |> assign_matches(matches)

    FootballratingsWeb.LiveStatsPubSub.subscribe()

    {:ok, socket}
  end

  @impl true
  def handle_info(%{"matches" => matches, "ratings" => ratings, "users" => users}, socket) do
    {
      :noreply,
      socket
      |> assign_users(users)
      |> assign_ratings(ratings)
      |> assign_matches(matches)
    }
  end

  defp assign_users(socket, users) do
    assign(socket, :users, users)
  end

  defp assign_ratings(socket, ratings) do
    assign(socket, :ratings, ratings)
  end

  defp assign_matches(socket, matches) do
    assign(socket, :matches, matches)
  end
end
