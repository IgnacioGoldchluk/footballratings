defmodule Footballratings.FootballInfo do
  @moduledoc """
  Context module for managing football information data.
  """

  alias Footballratings.Repo
  alias Footballratings.FootballInfo.{Team, League, Player, Match, PlayerMatch, Coach, CoachMatch}

  import Ecto.Query

  def get_all_leagues() do
    League
    |> Repo.all()
  end

  def create_team(attrs) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def get_team(team_id) do
    Repo.get(Team, team_id)
  end

  def get_match(match_id) do
    Repo.get(Match, match_id)
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

  def match_exists?(match_id), do: is_nil?(Repo.get(Match, match_id))
  def player_exists?(player_id), do: is_nil?(Repo.get(Player, player_id))

  defp is_nil?(nil), do: false
  defp is_nil?(_), do: true

  def set_match_status_to_ready(match_id) do
    Repo.get!(Match, match_id)
    |> Ecto.Changeset.change(status: :ready)
    |> Repo.update()
  end

  defp matches_with_teams_and_league() do
    Match.Query.preload_all_match_data() |> order_by([m], desc: m.timestamp)
  end

  def matches_available_for_rating() do
    Match.Query.available_for_rating()
    |> Repo.all()
  end

  def paginated_matches_available_for_rating(page_number \\ 0) do
    Match.Query.available_for_rating()
    |> Repo.paginate(page: page_number)
  end

  def get_match_with_team_and_league(match_id) do
    matches_with_teams_and_league()
    |> where([m], m.id == ^match_id)
    |> Repo.one()
  end

  def get_player(player_id) do
    Repo.get(Player, player_id)
  end

  def players_for_match(match_id) do
    Match.Query.preload_all_match_data()
    |> join(:left, [m], pr in assoc(m, :players_matches))
    |> join(:left, [m, ht, at, l, pr], p in assoc(pr, :player))
    |> join(:left, [m, ht, at, l, pr], prt in assoc(pr, :team))
    |> where([m], m.id == ^match_id)
    |> order_by([m, ht, at, l, pr, p], desc: pr.team_id)
    |> preload([m, ht, at, l, pr, p, prt], players_matches: {pr, [player: p, team: prt]})
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
    |> select([pm, p, t], struct(p, [:name, :id]))
    |> Repo.all()
  end

  def matches_for_player(player_id) do
    Match.Query.preload_all_match_data()
    |> join(:inner, [m], pm in assoc(m, :players_matches))
    |> join(:inner, [m, ht, at, l, pm], p in assoc(pm, :player))
    |> where([m, ht, at, l, pm, p], p.id == ^player_id)
    |> distinct([m], m.id)
    |> Repo.all()
  end

  def paginated_matches_for_player(player_id, page_number \\ 0) do
    Match.Query.preload_all_match_data()
    |> join(:inner, [m], pm in assoc(m, :players_matches))
    |> join(:inner, [m, ht, at, l, pm], p in assoc(pm, :player))
    |> where([m, ht, at, l, pm, p], p.id == ^player_id)
    |> distinct([m], m.id)
    |> Repo.paginate(page: page_number)
  end

  def matches_for_team(team_id) do
    Match.Query.preload_all_match_data()
    |> where([m, ht, at, l], ht.id == ^team_id or at.id == ^team_id)
    |> Repo.all()
  end

  def count_matches_for_team(team_id) do
    Match
    |> where([m], m.home_team_id == ^team_id or m.away_team_id == ^team_id)
    |> select(count())
    |> Repo.one()
  end

  def paginated_matches_for_team(team_id, page_number \\ 0) do
    Match.Query.preload_all_match_data()
    |> where([m, ht, at, l], ht.id == ^team_id or at.id == ^team_id)
    |> Repo.paginate(page: page_number)
  end

  def matches_available_for_rating_for_team(team_id) do
    matches_with_teams_and_league()
    |> where([m, ht, at, l], ht.id == ^team_id or at.id == ^team_id)
    |> Repo.all()
  end

  def matches_for_search_params(search_params) do
    Match.Query.for_search_params(search_params) |> Repo.all()
  end

  def paginated_matches_for_search_params(search_params, page_number \\ 0) do
    search_params
    |> Match.Query.for_search_params()
    |> Repo.paginate(page: page_number)
  end

  def players_for_search_params(search_params) do
    Player.Query.for_search_params(search_params)
    |> join(:left, [p], t in assoc(p, :team))
    |> preload([p, t], team: t)
    |> Repo.all()
  end

  def teams_for_search_params(search_params) do
    Team.Query.for_search_params(search_params) |> Repo.all()
  end

  def team_with_players(team_id) do
    Team.Query.for_team_id(team_id)
    |> Team.Query.current_players()
    |> Repo.one()
  end

  def teams_a_player_has_played_for(player_id) do
    Player
    |> where([p], p.id == ^player_id)
    |> join(:left, [p], t in assoc(p, :teams))
    |> preload([p, t], teams: t)
    |> distinct([p, t], t.id)
    |> order_by([p, t], desc: t.id)
    |> Repo.one()
  end

  def total_matches() do
    Match
    |> select(count())
    |> Repo.one()
  end
end
