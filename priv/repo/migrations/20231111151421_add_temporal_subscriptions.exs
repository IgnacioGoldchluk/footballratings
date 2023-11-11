defmodule Footballratings.Repo.Migrations.AddTemporalSubscriptions do
  use Ecto.Migration

  def change do
    create table(:temporal_subscriptions) do
      add :users_id, references(:users, on_delete: :delete_all), null: false
      add :plan_id, references(:plans, column: :external_id, type: :string), null: false
      timestamps()
    end
  end
end
