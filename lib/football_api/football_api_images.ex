defmodule FootballApi.FootballApiImages do
  @moduledoc """
  Fetches/stores player and team images/logos.
  """

  @behaviour FootballApi.FootballApiImages.Behaviour

  defp client_impl() do
    case Application.get_env(:footballratings, :images_provider, :local) do
      :real -> FootballApi.FootballApiImages.Real
      :local -> FootballApi.FootballApiImages.Local
    end
  end

  @impl FootballApi.FootballApiImages.Behaviour
  def player_image(player_id), do: client_impl().player_image(player_id)

  @impl FootballApi.FootballApiImages.Behaviour
  def team_image(team_id), do: client_impl().team_image(team_id)
end
