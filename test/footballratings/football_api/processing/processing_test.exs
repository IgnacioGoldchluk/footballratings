defmodule Footballratings.FootballApi.Processing.ProcessingTest do
  use Footballratings.DataCase

  describe "matches processing" do
    import Footballratings.ExternalMatchesFixtures

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

    test "match_finished? identifies correctly finished matches" do
      # Not started yet
      not_started_match_status = ["TBD", "NS", "ABD"] |> Enum.map(&create_status/1)

      matches = for _ <- 1..length(not_started_match_status), do: create_match()

      matches =
        [matches, not_started_match_status]
        |> Enum.zip()
        |> Enum.map(fn {match, status} -> insert_match_status(match, status) end)

      assert not Enum.any?(matches, &FootballApi.Processing.match_finished?/1)

      # In progress
      in_progress_match_status = ["1H", "HT", "2H", "ET", "BT", "P", "SUSP", "PST", "LIVE"]
      in_progress_match_status = Enum.map(in_progress_match_status, &create_status/1)

      matches = for _ <- 1..length(in_progress_match_status), do: create_match()

      matches =
        [matches, in_progress_match_status]
        |> Enum.zip()
        |> Enum.map(fn {match, status} -> insert_match_status(match, status) end)

      assert not Enum.any?(matches, &FootballApi.Processing.match_finished?/1)

      # Finished
      finished_match_status = ["FT", "AET", "PEN", "AWD", "WO"] |> Enum.map(&create_status/1)
      matches = for _ <- 1..length(finished_match_status), do: create_match()

      matches =
        [matches, finished_match_status]
        |> Enum.zip()
        |> Enum.map(fn {match, status} -> insert_match_status(match, status) end)

      assert Enum.all?(matches, &FootballApi.Processing.match_finished?/1)
    end
  end

  describe "lineups processing" do
    import Footballratings.ExternalLineupsFixtures

    test "extract coach from lineup" do
      coach = create_coach_lineup()

      lineup = create_lineup() |> insert_coach(coach)

      retrieved_coach = FootballApi.Processing.coach_from_lineup(lineup)

      assert retrieved_coach.name == coach.name
      assert retrieved_coach.id == coach.id
    end
  end
end
