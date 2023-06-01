defmodule Footballratings.Repo.Migrations.AddLeague do
  use Ecto.Migration

  def change do
    create table("leagues") do
      add :name, :string, null: false
    end
  end
end
