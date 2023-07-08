defmodule FootballratingsWeb.TeamPlayersHTML do
  use FootballratingsWeb, :html

  def show(assigns) do
    ~H"""
    <.link href={~p"/teams/#{@team_with_players.id}"}>
      <.button class="btn btn-primary">Back to team</.button>
    </.link>
    <.table
      id="players"
      rows={@team_with_players.players}
      row_click={fn %{id: player_id} -> JS.navigate(~p"/players/#{player_id}") end}
    >
      <:col :let={player} label="Name"><%= player.name %></:col>
    </.table>
    """
  end
end
