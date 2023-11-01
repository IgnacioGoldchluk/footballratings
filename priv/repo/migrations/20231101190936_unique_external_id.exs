defmodule Footballratings.Repo.Migrations.UniqueExternalId do
  use Ecto.Migration

  def change do
    create unique_index(:plans, [:external_id])
    create unique_index(:subscriptions, [:external_id])
  end
end
