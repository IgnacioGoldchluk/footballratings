defmodule Footballratings.Ratings.MatchRatings.Query do
  alias Footballratings.Ratings.MatchRatings
  alias Footballratings.FootballInfo.Match
  import Ecto.Query

  def base() do
    from(mr in MatchRatings)
    |> order_by([mr], desc: mr.inserted_at)
  end

  def by_user(users_id) do
    base()
    |> join(:left, [mr], u in assoc(mr, :users))
    |> join(:left, [mr], t in assoc(mr, :team))
    |> join(:left, [mr], m in assoc(mr, :match))
    |> where([mr, u, t, m], u.id == ^users_id)
    |> preload([mr, u, t, m], users: u, match: ^Match.Query.preload_all_match_data(), team: t)
  end
end
