defmodule FootballratingsWeb.MatchRatingsHTML do
  use FootballratingsWeb, :html

  def show(assigns) do
    ~H"""
    <div class="grid justify-items-center gap-2 place-content-center">
      <.link href={~p"/matches/#{@match.id}"} id="back-to-match-link">
        <.button class="btn btn-primary" id="back-to-match-button">Back to match</.button>
      </.link>
      <div class="flex space-x-1">
        <div>By</div>
        <.link href={~p"/ratings/users/#{@user.id}"} id="user-link">
          <div class="hover:text-primary" id="user-button"><%= @user.username %></div>
        </.link>
        <div>on</div>
        <div id="inserted-at"><%= @inserted_at %></div>
      </div>
      <h2 class="font-semibold" id="match-league-and-round">
        <%= @match.league.name %> - <%= @match.round %>
      </h2>
      <div class="flex flex-col" id="teams">
        <FootballratingsWeb.MatchComponents.team
          team={@match.home_team}
          goals={@match.goals_home}
          penalties={@match.penalties_home}
          pinned={@match.home_team.name == @team.name}
        />
        <FootballratingsWeb.MatchComponents.team
          team={@match.away_team}
          goals={@match.goals_away}
          penalties={@match.penalties_away}
          pinned={@match.away_team.name == @team.name}
        />
      </div>
      <.table
        id="player-ratings"
        rows={@player_ratings}
        row_click={fn %{player: player} -> JS.navigate(~p"/players/#{player.id}") end}
      >
        <:col :let={player_rating} label="Name"><%= player_rating.player.name %></:col>
        <:col :let={player_rating} label="Score"><%= player_rating.score %></:col>
      </.table>
    </div>
    """
  end
end
