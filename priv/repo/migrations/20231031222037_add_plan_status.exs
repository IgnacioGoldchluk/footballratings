defmodule Footballratings.Repo.Migrations.AddPlanStatus do
  use Ecto.Migration

  def change do
    alter table(:plans) do
      add :status, :string, null: false
    end
  end
end
