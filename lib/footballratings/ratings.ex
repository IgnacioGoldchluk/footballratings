defmodule Footballratings.Ratings do
  alias Footballratings.Repo
  alias Footballratings.Ratings.{PlayerRatings, MatchRatings}
  alias Footballratings.FootballInfo.Match

  import Ecto.Query

  def match_ratings_id(match_id, team_id, users_id) do
    result =
      from(mr in MatchRatings,
        where: mr.team_id == ^team_id and mr.match_id == ^match_id and mr.users_id == ^users_id
      )
      |> Repo.one()

    case result do
      nil -> nil
      existing -> existing.id
    end
  end

  def create_match_ratings(attrs) do
    %MatchRatings{}
    |> MatchRatings.changeset(attrs)
    |> Repo.insert()
  end

  def create_player_ratings(attrs) do
    %PlayerRatings{}
    |> PlayerRatings.changeset(attrs)
    |> Repo.insert()
  end

  def create_player_ratings!(attrs) do
    %PlayerRatings{}
    |> PlayerRatings.changeset(attrs)
    |> Repo.insert!()
  end

  def get_players_ratings(match_ratings_id) do
    from(mr in MatchRatings,
      where: mr.id == ^match_ratings_id,
      join: pr in assoc(mr, :player_ratings),
      join: t in assoc(mr, :team),
      join: m in assoc(mr, :match),
      join: u in assoc(mr, :users),
      left_join: p in assoc(pr, :player),
      preload: [
        match: ^Match.Query.preload_all_match_data(),
        player_ratings: {pr, [player: p]},
        users: u,
        team: t
      ]
    )
    |> Repo.one()
  end

  def create_match_and_players_ratings(players, scores, team_id, match_id, users_id) do
    Repo.transaction(fn ->
      {:ok, match_ratings} =
        create_match_ratings(%{users_id: users_id, team_id: team_id, match_id: match_id})

      # Must do it with changesets, otherwise the transaction raises instead of rolling back
      players
      |> players_ratings_maps(scores, match_ratings.id)
      |> Enum.each(&create_player_ratings!/1)

      match_ratings
    end)
  end

  def get_ratings_by_user(users_id) do
    MatchRatings.Query.by_user(users_id)
    |> Repo.all()
  end

  def count_ratings_by_user(users_id, after_time) do
    MatchRatings
    |> where([mr], mr.users_id == ^users_id)
    |> where([mr], mr.inserted_at >= ^after_time)
    |> select(count())
    |> Repo.one()
  end

  def paginated_ratings_by_user(users_id, page_number \\ 0) do
    MatchRatings.Query.by_user(users_id)
    |> Repo.paginate(page: page_number, page_size: 3)
  end

  def number_of_match_ratings(match_id) do
    from(mr in MatchRatings,
      where: mr.match_id == ^match_id,
      select: count(mr.id, :distinct)
    )
    |> Repo.one()
  end

  def count_match_ratings_for_team(team_id) do
    MatchRatings
    |> where([mr], mr.team_id == ^team_id)
    |> select(count())
    |> Repo.one()
  end

  def average_player_ratings(match_id) do
    from(pr in PlayerRatings,
      join: mr in assoc(pr, :match_ratings),
      join: m in assoc(mr, :match),
      where: m.id == ^match_id,
      group_by: pr.player_id,
      select: {pr.player_id, type(avg(pr.score), :float)}
    )
    |> Repo.all()
    |> Map.new()
  end

  def player_statistics(player_id) do
    PlayerRatings.Query.player_statistics()
    |> PlayerRatings.Query.for_player(player_id)
    |> Repo.all()
  end

  def player_statistics(player_id, team_name) do
    PlayerRatings.Query.player_statistics()
    |> PlayerRatings.Query.for_player(player_id)
    |> PlayerRatings.Query.for_team(team_name)
    |> Repo.all()
  end

  defp players_ratings_maps(players, scores, match_ratings_id) do
    players
    |> Enum.map(&Map.from_struct/1)
    |> Enum.map(fn player ->
      player
      |> Map.delete(:name)
      |> Map.put(:player_id, Map.get(player, :id))
      |> Map.put(:match_ratings_id, match_ratings_id)
      |> Map.put(
        :score,
        Map.get(scores, player[:id] |> Integer.to_string()) |> String.to_integer()
      )
    end)
  end

  def total_match_ratings() do
    MatchRatings
    |> select(count())
    |> Repo.one()
  end
end
