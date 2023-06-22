defmodule Footballratings.Repo.Migrations.DropDeprecatedIndexFromMatchRatings do
  use Ecto.Migration

  def change do
    drop index("match_ratings", [:match_id, :team_id, :user_id])
  end
end
