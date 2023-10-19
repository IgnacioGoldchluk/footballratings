defmodule Footballratings.ExternalMatchesFixtures do
  @moduledoc """
  Fixtures for data coming from the 3rd party API
  """

  @letters 'abcdefghijklmnoprqstuvwxyz'

  defp random_string() do
    for _ <- 1..10, into: "", do: <<Enum.random(@letters)>>
  end

  def create_league(id \\ System.unique_integer([:positive])) do
    %{
      "id" => id,
      "season" => :rand.uniform(10) + 2000,
      "round" => "Round #{:rand.uniform(37) + 1} of 38",
      "name" => "#{random_string()} League"
    }
  end

  def create_status(status \\ "FT"), do: %{"short" => status}

  def create_team(id \\ System.unique_integer([:positive])) do
    %{
      "id" => id,
      "name" => "#{random_string()} F.C."
    }
  end

  defp nil_score_attrs(), do: %{"home" => nil, "away" => nil}

  defp valid_score_attrs() do
    %{"home" => :rand.uniform(7), "away" => :rand.uniform(7)}
  end

  def create_score() do
    %{
      "extratime" => nil_score_attrs(),
      "penalty" => nil_score_attrs(),
      "fulltime" => valid_score_attrs(),
      "halftime" => %{"home" => 0, "away" => 0}
    }
  end

  def valid_penalties_score_attrs() do
    %{
      "extratime" => %{"home" => 2, "away" => 2},
      "halftime" => %{"home" => 0, "away" => 1},
      "fulltime" => %{"home" => 1, "away" => 1},
      "penalty" => %{"home" => 5, "away" => 4}
    }
  end

  def create_match() do
    %{
      "fixture" => create_fixture(),
      "score" => create_score(),
      "teams" => create_teams(),
      "league" => create_league()
    }
  end

  def create_teams() do
    # Make sure both teams are different
    team1_id = System.unique_integer([:positive])
    team2_id = System.unique_integer([:positive])

    %{
      "home" => create_team(team1_id),
      "away" => create_team(team2_id)
    }
  end

  def create_fixture(id \\ System.unique_integer([:positive])) do
    %{
      "status" => create_status(),
      "id" => id,
      "timestamp" => System.unique_integer([:positive])
    }
  end

  def insert_fixture(match, fixture), do: Map.put(match, "fixture", fixture)

  def insert_league(match, league), do: Map.put(match, "league", league)

  def insert_home_team(match, home_team), do: put_in(match, ["teams", "home_team"], home_team)

  def insert_away_team(match, away_team), do: put_in(match, ["teams", "away_team"], away_team)

  def insert_match_status(match, new_status), do: put_in(match, ["fixture", "status"], new_status)

  def insert_score(match, score), do: Map.put(match, "score", score)
end
