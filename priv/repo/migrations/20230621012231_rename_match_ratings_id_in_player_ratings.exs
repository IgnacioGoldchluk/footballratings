defmodule Footballratings.Repo.Migrations.RenameMatchRatingsIdInPlayerRatings do
  use Ecto.Migration

  def change do
    rename(table(:player_ratings), :match_rating_id, to: :match_ratings_id)
  end
end
