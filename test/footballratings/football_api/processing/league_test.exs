defmodule Footballratings.FootballApi.Processing.LeagueTest do
  use Footballratings.DataCase

  describe "FootballAPI league processing" do
    @league %{"id" => 123, "season" => 2023, "name" => "First Division"}
    @duplicated_league %{"id" => 123, "season" => 2022, "name" => "Second Division"}

    test "to_internal_schema/1 converts to a valid schema and inserts in the DB" do
      internal_schema = FootballApi.Processing.League.to_internal_schema(@league)

      {:ok, league_in_db} = Footballratings.FootballInfo.maybe_create_league(internal_schema)

      assert @league["id"] == league_in_db.id
      assert @league["season"] == league_in_db.season
      assert @league["name"] == league_in_db.name
    end

    test "a duplicated league overrides the first one" do
      @league
      |> FootballApi.Processing.League.to_internal_schema()
      |> Footballratings.FootballInfo.maybe_create_league()

      [@duplicated_league]
      |> Enum.map(&FootballApi.Processing.League.to_internal_schema/1)
      |> Footballratings.FootballInfo.maybe_create_leagues()

      league = Repo.get(Footballratings.FootballInfo.League, @duplicated_league.id)

      assert league.season == @duplicated_league["season"]
      assert league.name == @duplicated_league["name"]
    end
  end
end
