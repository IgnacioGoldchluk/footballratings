defmodule Footballratings.FootballApi.DecoderTests do
  use Footballratings.DataCase

  alias FootballApi.Models

  import FootballApi.ApiResponsesFixtures

  describe "decoders structs" do
    test "squads" do
      assert {:ok, %Models.Lineups.Response{}} =
               Poison.decode(squads_body(), as: Models.Lineups.Struct.lineups())
    end

    test "matches" do
      assert {:ok, %Models.Matches.Response{}} =
               Poison.decode(
                 matches_body(),
                 as: Models.Matches.Struct.match()
               )
    end

    test "players_statistics" do
      assert {:ok, %Models.PlayersStatistics.Response{}} =
               Poison.decode(players_statistics_body(),
                 as: Models.PlayersStatistics.Struct.players_statistics()
               )
    end

    test "lineups" do
      assert {:ok, %Models.Lineups.Response{}} =
               Poison.decode(
                 lineups_body(),
                 as: Models.Lineups.Struct.lineups()
               )
    end
  end
end
