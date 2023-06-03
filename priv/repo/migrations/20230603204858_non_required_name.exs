defmodule Footballratings.Repo.Migrations.NonRequiredName do
  use Ecto.Migration

  def change do
    alter table("players") do
      modify(:firstname, :string, null: true)
      modify(:lastname, :string, null: true)
    end

    alter table("coaches") do
      modify(:firstname, :string, null: true)
      modify(:lastname, :string, null: true)
    end
  end
end
