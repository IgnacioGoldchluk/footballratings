defmodule Footballratings.FootballApi.FootballApiImagesTest do
  use Footballratings.DataCase

  describe "real images links" do
    test "player_image/1" do
      player_id = 123
      expected = "https://media.api-sports.io/football/players/#{player_id}.png"
      assert expected == FootballApi.FootballApiImages.Real.player_image(player_id)
    end

    test "team_image/1" do
      team_id = 456
      expected = "https://media.api-sports.io/football/teams/#{team_id}.png"
      assert expected == FootballApi.FootballApiImages.Real.team_image(team_id)
    end
  end
end
