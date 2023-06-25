defmodule Footballratings.Repo.Migrations.MatchAndPlayerRatings do
  use Ecto.Migration

  def change do
    create table(:match_ratings) do
      add(:match_id, references(:matches))
      add(:team_id, references(:teams))
      add(:user_id, references(:users))
      timestamps()
    end

    create table(:player_ratings) do
      add(:score, :integer, null: false)
      add(:player_id, references(:players))
      add(:match_rating_id, references(:match_ratings))
      timestamps()
    end

    create(unique_index(:match_ratings, [:match_id, :team_id, :user_id]))
  end
end
