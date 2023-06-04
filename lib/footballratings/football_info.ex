defmodule Footballratings.FootballInfo do
  @moduledoc """
  Context module for managing football information data.
  """

  alias Footballratings.Repo
  alias Footballratings.FootballInfo.{Team, League, Player, Match, PlayerMatch}

  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def maybe_create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert!(on_conflict: :nothing)
  end

  def maybe_create_teams(teams) do
    Repo.insert_all(Team, teams, on_conflict: :replace_all)
  end

  def maybe_create_league(attrs \\ %{}) do
    %League{}
    |> League.changeset(attrs)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: :id)
  end

  def maybe_create_leagues(leagues) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    placeholders = %{timestamp: timestamp}

    leagues =
      Enum.map(
        leagues,
        &Map.merge(&1, %{
          inserted_at: {:placeholder, :timestamp},
          updated_at: {:placeholder, :timestamp}
        })
      )

    Repo.insert_all(League, leagues,
      placeholders: placeholders,
      on_conflict: :replace_all,
      conflict_target: :id
    )
  end

  def maybe_create_players(players) do
    Repo.insert_all(Player, players, on_conflict: :replace_all)
  end

  def maybe_create_matches(matches) do
    Repo.insert_all(Match, matches, on_conflict: :replace_all)
  end

  def create_players_match(players) do
    Repo.insert_all(PlayerMatch, players, on_conflict: :replace_all)
  end
end
