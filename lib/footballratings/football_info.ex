defmodule Footballratings.FootballInfo do
  @moduledoc """
  Context module for managing football information data.
  """

  alias Footballratings.Repo
  alias Footballratings.FootballInfo.{Team, League, Player, Match, PlayerMatch, Coach, CoachMatch}

  import Ecto.Query

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
    {teams, placeholders} = Repo.insert_timestamp_placeholders(teams)

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
    {leagues, placeholders} = Repo.insert_timestamp_placeholders(leagues)

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
    {coaches, placeholders} = Repo.insert_timestamp_placeholders(coaches)

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
    {coaches_matches, placeholders} = Repo.insert_timestamp_placeholders(coaches_matches)

    Repo.insert_all(CoachMatch, coaches_matches, placeholders: placeholders)
  end

  def maybe_create_players(players) do
    {players, placeholders} = Repo.insert_timestamp_placeholders(players)

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
    {matches, placeholders} = Repo.insert_timestamp_placeholders(matches)

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
    {players_matches, placeholders} = Repo.insert_timestamp_placeholders(players_matches)

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

  defp matches_with_teams_and_league() do
    from(m in Match,
      join: ht in Team,
      on: m.home_team_id == ht.id,
      join: at in Team,
      on: m.away_team_id == at.id,
      join: l in League,
      on: l.id == m.league_id,
      order_by: [desc: m.timestamp],
      select: %{
        match: m,
        home_team: %{name: ht.name, id: ht.id},
        away_team: %{name: at.name, id: at.id},
        league_name: l.name
      }
    )
  end

  def matches_available_for_rating() do
    matches_with_teams_and_league()
    |> where([m], m.status == :ready)
    |> Repo.all()
  end

  def get_match_with_team_and_league(match_id) do
    matches_with_teams_and_league()
    |> where([m], m.id == ^match_id)
    |> Repo.one()
  end

  def players_for_match(match_id, team_id) do
    from(pm in PlayerMatch,
      join: p in Player,
      on: pm.player_id == p.id,
      join: t in Team,
      on: pm.team_id == t.id
    )
    |> where([pm], pm.match_id == ^match_id)
    |> where([pm, p, t], t.id == ^team_id)
    |> order_by([pm, p, t], asc: p.name)
    |> select([pm, p, t], %{name: p.name, id: p.id})
    |> Repo.all()
  end

  def matches_available_for_rating_for_team(team_id) do
    matches_with_teams_and_league()
    |> where([m, ht, at, l], ht.id == ^team_id or at.id == ^team_id)
    |> Repo.all()
  end
end
