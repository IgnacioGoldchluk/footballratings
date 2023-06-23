defmodule Footballratings.Ratings do
  alias Footballratings.Repo
  alias Footballratings.Ratings.{PlayerRatings, MatchRatings}

  import Ecto.Query

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
      join: m in assoc(mr, :match),
      join: u in assoc(mr, :users),
      left_join: ht in assoc(m, :home_team),
      left_join: at in assoc(m, :away_team),
      left_join: l in assoc(m, :league),
      left_join: p in assoc(pr, :player),
      preload: [
        match: {m, [home_team: ht, away_team: at, league: l]},
        player_ratings: {pr, [player: p]},
        users: u
      ]
    )
    |> Repo.all()
  end

  def create_match_and_players_ratings(players, scores, team_id, match_id, users_id) do
    Repo.transaction(fn ->
      {:ok, match_ratings} =
        create_match_ratings(%{users_id: users_id, team_id: team_id, match_id: match_id})

      # Must do it with changesets, otherwise the transaction raises instead of rolling back
      players
      |> players_ratings_maps(scores, match_ratings.id)
      |> Enum.map(&create_player_ratings!/1)

      match_ratings.id
    end)
  end

  def get_ratings_by_user(users_id) do
    from(mr in MatchRatings,
      join: u in assoc(mr, :users),
      join: t in assoc(mr, :team),
      join: m in assoc(mr, :match),
      join: ht in assoc(m, :home_team),
      join: at in assoc(m, :away_team),
      join: l in assoc(m, :league),
      where: u.id == ^users_id,
      preload: [
        users: u,
        match: {m, [home_team: ht, away_team: at, league: l]},
        team: t
      ]
    )
    |> Repo.all()
  end

  def number_of_match_ratings(match_id) do
    from(mr in MatchRatings,
      where: mr.match_id == ^match_id,
      select: count(mr.id, :distinct)
    )
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

  defp players_ratings_maps(players, scores, match_ratings_id) do
    players
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
end
