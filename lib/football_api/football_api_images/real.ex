defmodule FootballApi.FootballApiImages.Real do
  @behaviour FootballApi.FootballApiImages.Behaviour

  @impl FootballApi.FootballApiImages.Behaviour
  def player_image(player_id) do
    "https://media.api-sports.io/football/players/#{player_id}.png"
  end

  @impl FootballApi.FootballApiImages.Behaviour
  def team_image(team_id) do
    "https://media.api-sports.io/football/teams/#{team_id}.png"
  end
end
