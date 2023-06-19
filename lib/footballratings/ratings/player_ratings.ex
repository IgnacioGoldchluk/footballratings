defmodule Footballratings.Ratings.PlayerRatings do
  use Ecto.Schema
  import Ecto.Changeset

  alias Footballratings.Ratings.MatchRatings
  alias Footballratings.FootballInfo.Player

  schema "player_ratings" do
    field :score, :integer
    belongs_to(:player, Player)
    belongs_to(:match_rating, MatchRatings)

    timestamps()
  end

  def changeset(player_rating, attrs) do
    player_rating
    |> cast(attrs, [:score, :player_id, :match_rating_id])
    |> foreign_key_constraint(:player_id)
    |> foreign_key_constraint(:match_rating_id)
    |> validate_inclusion(:score, 1..10)
  end
end
