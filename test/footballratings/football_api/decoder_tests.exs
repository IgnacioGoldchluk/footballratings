defmodule Footballratings.FootballApi.DecoderTests do
  use Footballratings.DataCase

  alias FootballApi.Models

  @path "test/footballratings/football_api/responses"

  describe "decoders structs" do
    test "squads" do
      {:ok, contents} = File.read("#{@path}/squads.txt")

      assert {:ok, %Models.Lineups.Response{}} =
               Poison.decode(contents, as: Models.Lineups.Struct.lineups())
    end

    test "matches" do
      {:ok, contents} = File.read("#{@path}/matches.txt")

      assert {:ok, %Models.Matches.Response{}} =
               Poison.decode(
                 contents,
                 as: Models.Matches.Struct.match()
               )
    end

    test "players_statistics" do
      {:ok, contents} = File.read("#{@path}/players_statistics.txt")

      assert {:ok, %Models.PlayersStatistics.Response{}} =
               Poison.decode(contents, as: Models.PlayersStatistics.Struct.players_statistics())
    end
  end
end
