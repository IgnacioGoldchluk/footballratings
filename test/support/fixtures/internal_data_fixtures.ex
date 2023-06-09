defmodule Footballratings.InternalDataFixtures do
  def create_league(attrs \\ %{}) do
    {:ok, league} =
      attrs
      |> Enum.into(%{name: "First Division", season: 2023, id: System.unique_integer([:positive])})
      |> Footballratings.FootballInfo.maybe_create_league()

    league
  end

  def create_team(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{name: "Team FC", id: System.unique_integer([:positive])})
      |> Footballratings.FootballInfo.create_team()

    team
  end

  def create_player(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{name: "L. Acosta", age: 35, id: System.unique_integer([:positive])})
      |> Footballratings.FootballInfo.create_player()

    player
  end

  def create_match(attrs \\ %{}) do
    {:ok, match} =
      attrs
      |> Enum.into(%{
        round: "1 of 38",
        season: 2023,
        timestamp: System.unique_integer([:positive]),
        goals_home: :rand.uniform(6),
        goals_away: :rand.uniform(6),
        penalties_home: nil,
        penalties_away: nil,
        status: :ready,
        id: System.unique_integer([:positive])
      })
      |> Footballratings.FootballInfo.create_match()

    match
  end
end
