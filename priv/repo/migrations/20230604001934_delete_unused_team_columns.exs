defmodule Footballratings.Repo.Migrations.DeleteUnusedTeamColumns do
  use Ecto.Migration

  def change do
    alter table("teams") do
      remove(:code)
      remove(:country)
      remove(:founded)
      remove(:national)
    end
  end
end
