defmodule Footballratings.FootballApi.Processing.ProcessingTest do
  use Footballratings.DataCase

  import Footballratings.ExternalMatchesFixtures

  describe "matches processing" do
    test "unique leagues returns unique leagues" do
      leagues = [1, 2, 3, 4, 4, 2, 4, 1] |> Enum.map(&create_league/1)

      # Create a number of matches equal to the leagues
      matches = for _ <- 1..length(leagues), do: create_match()
      # Create and insert the leagues
      matches =
        [matches, leagues]
        |> Enum.zip()
        |> Enum.map(fn {match, league} -> insert_league(match, league) end)

      unique_leagues = FootballApi.Processing.unique_leagues(matches)

      assert length(unique_leagues) == 4
    end
  end
end
