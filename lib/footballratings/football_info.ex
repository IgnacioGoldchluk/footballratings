defmodule Footballratings.FootballInfo do
  @moduledoc """
  Context module for managing football information data.
  """

  alias Footballratings.Repo
  alias Footballratings.FootballInfo.{Team, League, Player, Match, PlayerMatch}

  def create_team(attrs) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def maybe_create_team(attrs) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: :id)
  end

  def maybe_create_teams(teams) do
    {teams, placeholders} = insert_timestamp_placeholders(teams)

    Repo.insert_all(Team, teams,
      placeholders: placeholders,
      on_conflict: :replace_all,
      conflict_target: :id
    )
  end

  def maybe_create_league(attrs) do
    %League{}
    |> League.changeset(attrs)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: :id)
  end

  def maybe_create_leagues(leagues) do
    {leagues, placeholders} = insert_timestamp_placeholders(leagues)

    Repo.insert_all(League, leagues,
      placeholders: placeholders,
      on_conflict: :replace_all,
      conflict_target: :id
    )
  end

  def create_player(attrs) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  def maybe_create_players(players) do
    {players, placeholders} = insert_timestamp_placeholders(players)

    Repo.insert_all(Player, players,
      placeholders: placeholders,
      on_conflict: :replace_all,
      conflict_target: :id
    )
  end

  def create_matches(matches) do
    Repo.insert_all(Match, matches)
  end

  def create_players_match(players) do
    Repo.insert_all(PlayerMatch, players, on_conflict: :replace_all)
  end

  def match_exists?(match_id) do
    case Repo.get(Match, match_id) do
      nil -> false
      %Match{} -> true
    end
  end

  defp insert_timestamp_placeholders(structs) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    placeholders = %{timestamp: timestamp}

    new_structs =
      Enum.map(
        structs,
        &Map.merge(&1, %{
          inserted_at: {:placeholder, :timestamp},
          updated_at: {:placeholder, :timestamp}
        })
      )

    {new_structs, placeholders}
  end
end
