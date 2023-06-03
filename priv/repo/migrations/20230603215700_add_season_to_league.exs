defmodule Footballratings.Repo.Migrations.AddSeasonToLeague do
  use Ecto.Migration

  def change do
    alter table("leagues") do
      add(:season, :integer, null: false)
    end
  end
end
