defmodule FootballApi.FootballApiImages.Behaviour do
  @callback player_image(String.t() | integer()) :: String.t()
  @callback team_image(String.t() | integer()) :: String.t()
end
