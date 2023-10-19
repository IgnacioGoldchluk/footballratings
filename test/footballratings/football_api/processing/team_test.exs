defmodule Footballratings.FootballApi.Processing.TeamTest do
  use Footballratings.DataCase

  describe "FootballAPI team processing" do
    test "to_internal_schema/1 converts to a valid schema and inserts in the DB" do
      team = %{"id" => System.unique_integer([:positive]), "name" => "Team FC"}

      internal_schema = FootballApi.Processing.Team.to_internal_schema(team)

      {:ok, team_in_db} = Footballratings.FootballInfo.create_team(internal_schema)

      assert team["id"] == team_in_db.id
      assert team["name"] == team_in_db.name
    end

    test "a duplicated team overrides the first one" do
      team = %{"id" => System.unique_integer([:positive]), "name" => "Team FC"}

      team
      |> FootballApi.Processing.Team.to_internal_schema()
      |> Footballratings.FootballInfo.create_team()

      duplicated_team = %{"id" => team["id"], "name" => "Other Team FC"}

      [duplicated_team]
      |> Enum.map(&FootballApi.Processing.Team.to_internal_schema/1)
      |> Footballratings.FootballInfo.maybe_create_teams()

      new_team = Repo.get(Footballratings.FootballInfo.Team, team.id)

      assert new_team.name == duplicated_team.name

      yet_another_team = %{"id" => team.id, "name" => "Yet Another Team FC"}

      yet_another_team
      |> FootballApi.Processing.Team.to_internal_schema()
      |> Footballratings.FootballInfo.maybe_create_team()

      new_team = Repo.get(Footballratings.FootballInfo.Team, team.id)

      assert new_team.name == yet_another_team.name
    end
  end
end
