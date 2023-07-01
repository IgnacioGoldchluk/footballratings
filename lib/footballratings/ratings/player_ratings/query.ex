defmodule Footballratings.Ratings.PlayerRatings.Query do
  alias Footballratings.Ratings.PlayerRatings

  import Ecto.Query

  def base() do
    PlayerRatings
  end

  def player_statistics() do
    base()
    |> join(:left, [pr], p in assoc(pr, :player))
    |> join(:left, [pr, p], m in assoc(pr, :match))
    |> join(:left, [pr, p, m], mr in assoc(pr, :match_ratings))
    |> join(:left, [pr, p, m, mr], t in assoc(mr, :team))
    |> group_by([pr, p, m, mr, t], [m.id, t.id])
    |> order_by([pr, p, m, mr, t], asc: m.timestamp)
    |> select(
      [pr, p, m, mr, t],
      %{
        average: type(avg(pr.score), :float),
        timestamp: m.timestamp,
        team: t.name
      }
    )
  end

  def for_player(query, player_id) do
    query
    |> where([pr, p], p.id == ^player_id)
  end

  def for_team(query, team_name) do
    query
    |> where([pr, p, m, mr, t], t.name == ^team_name)
  end
end
