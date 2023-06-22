defmodule Footballratings.Repo.Migrations.RenameUserIdToUsersId do
  use Ecto.Migration

  def change do
    rename table(:match_ratings), :user_id, to: :users_id
    create(unique_index(:match_ratings, [:match_id, :team_id, :users_id]))
  end
end
