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
    |> Repo.insert!(on_conflict: :replace_all)
  end

  def maybe_create_leagues(leagues) do
    Repo.insert_all(League, leagues, on_conflict: :replace_all)
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
