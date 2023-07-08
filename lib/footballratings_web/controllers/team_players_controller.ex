defmodule FootballratingsWeb.TeamPlayersController do
  use FootballratingsWeb, :controller
  alias Footballratings.FootballInfo

  @impl true
  def show(conn, %{"team_id" => team_id}) do
    team_with_players =
      team_id
      |> String.to_integer()
      |> FootballInfo.team_with_players()

    render(conn, :show, team_with_players: team_with_players)
  end
end
