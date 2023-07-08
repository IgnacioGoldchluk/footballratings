defmodule FootballratingsWeb.TeamPlayersHTML do
  use FootballratingsWeb, :html

  @impl true
  def show(assigns) do
    ~H"""
      <.link href={~p"/teams/#{@team_with_players.id}"}>
        <.button class="btn btn-primary">Back to team</.button>
      </.link>
      <table class="table table-zebra">
        <thead>
          <tr>
            <th>Player</th>
          </tr>
        </thead>
        <tbody>
          <%= for player <- @team_with_players.players do %>
            <tr>
              <td>
                <FootballratingsWeb.PlayerComponents.player_link id={player.id} name={player.name} />
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    """
  end
end
