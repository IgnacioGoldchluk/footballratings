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

    test "unique teams returns unique teams" do
      teams = [1, 2, 3, 4, 2, 5] |> Enum.map(&create_team/1)
      # Create number of matches equal to half of the teams, since
      # a match always contains HOME + AWAY team
      matches = for _ <- 1..div(length(teams), 2), do: create_match()

      matches =
        [matches, Enum.chunk_every(teams, 2)]
        |> Enum.zip()
        |> Enum.map(fn {match, [home_team, away_team]} ->
          match
          |> insert_home_team(home_team)
          |> insert_away_team(away_team)
        end)

      unique_teams = FootballApi.Processing.unique_teams(matches)

      assert length(unique_teams) == 5
    end

    test "unique matches returns unique matches" do
      fixtures = [1, 2, 4, 5, 5, 6, 1, 2, 3] |> Enum.map(&create_fixture/1)

      matches = for _ <- 1..length(fixtures), do: create_match()

      matches =
        [matches, fixtures]
        |> Enum.zip()
        |> Enum.map(fn {match, fixture} -> insert_fixture(match, fixture) end)

      unique_matches = FootballApi.Processing.unique_matches(matches)

      assert length(unique_matches) == 6
    end
  end
end
