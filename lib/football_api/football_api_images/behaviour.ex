defmodule FootballApi.FootballApiImages.Behaviour do
  @moduledoc """
  Behaviour to fetch players and teams images.
  """

  @callback player_image(String.t() | integer()) :: String.t()
  @callback team_image(String.t() | integer()) :: String.t()
end
