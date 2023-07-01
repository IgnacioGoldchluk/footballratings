defmodule FootballratingsWeb.MatchRatingsHTML do
  use FootballratingsWeb, :html

  def show(assigns) do
    ~H"""
    <div class="grid justify-items-center gap-2 place-content-center">
      <div class="flex space-x-1">
        <div>By</div>
        <.link href={~p"/ratings/users/#{@user.id}"}>
          <div class="hover:text-primary"><%= @user.username %></div>
        </.link>
        <div>on</div>
        <div><%= @inserted_at %></div>
      </div>
      <FootballratingsWeb.MatchComponents.match_result match={@match} />
      <table class="table table-zebra">
        <thead>
          <tr>
            <th>Player</th>
            <th>Score</th>
          </tr>
        </thead>
        <tbody>
          <%= for player_rating <- @player_ratings do %>
            <tr>
              <td><.link href={~p"/players/#{player_rating.player.id}"} class="hover:text-primary"><%= player_rating.player.name %></.link></td>
              <td><%= player_rating.score %></td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end
