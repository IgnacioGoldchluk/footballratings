defmodule Footballratings.Ratings.MatchRatings do
  use Ecto.Schema
  import Ecto.Changeset

  alias Footballratings.FootballInfo.{Match, Team}
  alias Footballratings.Accounts.{Users}

  schema "match_ratings" do
    belongs_to(:match, Match)
    belongs_to(:team, Team)
    belongs_to(:user, Users)

    timestamps()
  end

  def changeset(match_ratings, attrs) do
    match_ratings
    |> cast(attrs, [:match_id, :team_id, :user_id])
    |> foreign_key_constraint(:match_id)
    |> foreign_key_constraint(:team_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:match_id, :team_id, :user_id])
  end
end
