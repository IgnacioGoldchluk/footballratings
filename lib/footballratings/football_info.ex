defmodule Footballratings.FootballInfo do
  @moduledoc """
  Context module for managing football information data.
  """

  alias Footballratings.Repo
  alias Footballratings.FootballInfo.{Team, League, Player, Match, PlayerMatch, Coach, CoachMatch}

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

  def create_coach(attrs) do
    %Coach{}
    |> Coach.changeset(attrs)
    |> Repo.insert()
  end

  def maybe_create_coaches(coaches) do
    {coaches, placeholders} = insert_timestamp_placeholders(coaches)

    Repo.insert_all(Coach, coaches,
      placeholders: placeholders,
      on_conflict: :replace_all,
      conflict_target: :id
    )
  end

  def create_coach_match(attrs) do
    %CoachMatch{}
    |> CoachMatch.changeset(attrs)
    |> Repo.insert()
  end

  def create_coaches_matches(coaches_matches) do
    {coaches_matches, placeholders} = insert_timestamp_placeholders(coaches_matches)

    Repo.insert_all(CoachMatch, coaches_matches, placeholders: placeholders)
  end

  def maybe_create_players(players) do
    {players, placeholders} = insert_timestamp_placeholders(players)

    Repo.insert_all(Player, players,
      placeholders: placeholders,
      on_conflict: :replace_all,
      conflict_target: :id
    )
  end

  def create_match(attrs) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  def create_matches(matches) do
    {matches, placeholders} = insert_timestamp_placeholders(matches)

    Repo.insert_all(Match, matches,
      placeholders: placeholders,
      on_conflict: :replace_all,
      conflict_target: :id
    )
  end

  def create_player_match(attrs) do
    %PlayerMatch{}
    |> PlayerMatch.changeset(attrs)
    |> Repo.insert()
  end

  def create_players_matches(players_matches) do
    {players_matches, placeholders} = insert_timestamp_placeholders(players_matches)

    Repo.insert_all(PlayerMatch, players_matches,
      placeholders: placeholders,
      on_conflict: :replace_all,
      conflict_target: :id
    )
  end

  def match_exists?(match_id) do
    case Repo.get(Match, match_id) do
      nil -> false
      %Match{} -> true
    end
  end

  def set_match_status_to_ready(match_id) do
    Repo.get!(Match, match_id)
    |> Ecto.Changeset.change(status: :ready)
    |> Repo.update()
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
