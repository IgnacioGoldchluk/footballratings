defmodule Footballratings.Repo.Migrations.AllowNullUsername do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify(:username, :string, null: true, from: :string)
    end
  end
end
