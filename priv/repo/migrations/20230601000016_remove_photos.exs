defmodule Footballratings.Repo.Migrations.RemovePhotos do
  use Ecto.Migration

  def change do
    alter table("teams") do
      remove :logo
    end

    alter table("players") do
      remove :photo
    end

    alter table("coaches") do
      remove :photo
    end
  end
end
