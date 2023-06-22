defmodule Footballratings.Ratings.MatchRatings do
  use Ecto.Schema
  import Ecto.Changeset

  alias Footballratings.FootballInfo.{Match, Team}
  alias Footballratings.Accounts.{Users}
  alias Footballratings.Ratings.PlayerRatings

  schema "match_ratings" do
    belongs_to(:match, Match)
    belongs_to(:team, Team)
    belongs_to(:users, Users)

    has_many(:player_ratings, PlayerRatings)

    timestamps()
  end

  def changeset(match_ratings, attrs) do
    match_ratings
    |> cast(attrs, [:match_id, :team_id, :users_id])
    |> foreign_key_constraint(:match_id)
    |> foreign_key_constraint(:team_id)
    |> foreign_key_constraint(:users_id)
    |> unique_constraint([:match_id, :team_id, :users_id])
  end
end
