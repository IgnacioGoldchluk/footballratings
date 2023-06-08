defmodule Footballratings.FootballInfo.FootballInfoTest do
  use Footballratings.DataCase

  alias Footballratings.FootballInfo.{Team, Player}

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

  describe "players" do
    test "create_player/1 with valid params creates a player" do
      team = %{id: System.unique_integer([:positive]), name: "Chelsea FC"}

      player_attrs = %{
        name: "M Kovacic",
        age: 30,
        id: System.unique_integer([:positive]),
        team_id: team.id
      }

      Footballratings.FootballInfo.create_team(team)

      {:ok, player} = Footballratings.FootballInfo.create_player(player_attrs)

      assert player.name == player_attrs[:name]
      assert player.age == player_attrs[:age]
      assert player.id == player_attrs[:id]
      assert player.team_id == player_attrs.team_id

      # He switched to Manchester City
      team = %{id: System.unique_integer([:positive]), name: "Manchester City FC"}
      Footballratings.FootballInfo.create_team(team)
      player_attrs = %{player_attrs | team_id: team.id}

      Footballratings.FootballInfo.maybe_create_players([player_attrs])

      player = Repo.get(Player, player_attrs[:id]) |> Repo.preload(:team)

      assert player.team.name == "Manchester City FC"
    end
  end
end
