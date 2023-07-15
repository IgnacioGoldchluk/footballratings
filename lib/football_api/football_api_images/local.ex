defmodule FootballApi.FootballApiImages.Local do
  @behaviour FootballApi.FootballApiImages.Behaviour

  @impl FootballApi.FootballApiImages.Behaviour
  def player_image(_player_id) do
    "/images/player.jpg"
  end

  @impl FootballApi.FootballApiImages.Behaviour
  def team_image(_team_id) do
    "/images/team.jpg"
  end
end
