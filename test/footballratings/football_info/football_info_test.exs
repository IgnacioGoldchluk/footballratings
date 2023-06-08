defmodule Footballratings.FootballInfo.FootballInfoTest do
  use Footballratings.DataCase

  alias Footballratings.FootballInfo.Team

  describe "teams" do
    test "create_team/1 creates a team" do
      valid_attrs = %{name: "Team FC", id: System.unique_integer()}

      assert {:ok, %Team{} = team} = Footballratings.FootballInfo.create_team(valid_attrs)
      assert team.name == valid_attrs[:name]
      assert team.id == valid_attrs[:id]
    end

    test "create_team/1 without attributes fails" do
      invalid_attrs = %{}
      assert {:error, %Ecto.Changeset{}} = Footballratings.FootballInfo.create_team(invalid_attrs)
    end
  end
end
