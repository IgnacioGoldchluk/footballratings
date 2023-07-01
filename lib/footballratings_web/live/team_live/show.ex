defmodule FootballratingsWeb.TeamLive.Show do
  use FootballratingsWeb, :live_view
  alias Footballratings.FootballInfo

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-secondary">
      <FootballratingsWeb.TeamComponents.team_name_and_logo
        name={@team_with_players.name}
        id={@team_with_players.id}
      />
    </div>
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

  @impl true
  def mount(%{"team_id" => team_id}, _session, socket) do
    {:ok, socket |> assign_team_with_players(team_id)}
  end

  defp assign_team_with_players(socket, team_id) do
    team_with_players =
      team_id
      |> String.to_integer()
      |> FootballInfo.team_with_players()

    assign(socket, :team_with_players, team_with_players)
  end
end
