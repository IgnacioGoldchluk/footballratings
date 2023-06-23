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
      <div class="grid gap-4 grid-cols-3">
        <%= for player_rating <- @player_ratings do %>
          <div class="grid grid-cols-2 justify-around bg-secondary border-2 border-primary rounded-lg w-48 px-4 py-1">
            <FootballratingsWeb.PlayerComponents.player_rating_box
              player={player_rating.player}
              score={player_rating.score}
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
