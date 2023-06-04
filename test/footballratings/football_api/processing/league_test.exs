defmodule Footballratings.FootballApi.Processing.LeagueTest do
  use Footballratings.DataCase

  describe "FootballAPI league processing" do
    alias FootballApi.Models.Matches.League

    @league %League{id: 123, season: 2023, name: "First Division"}

    test "to_internal_league_schema/1 converts to a valid schema" do
      internal_schema = FootballApi.Processing.League.to_internal_league_schema(@league)

      {:ok, league_in_db} = Footballratings.FootballInfo.maybe_create_league(internal_schema)

      assert @league.id == league_in_db.id
      assert @league.season == league_in_db.season
      assert @league.name == league_in_db.name
    end
  end
end
