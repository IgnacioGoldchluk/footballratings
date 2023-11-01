defmodule Footballratings.Repo.Migrations.PlanAndSubscription do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :external_id, :string, null: false
      add :frequency, :integer, null: false
      add :frequency_type, :string, null: false
      add :amount, :integer, null: false
      add :currency, :string, null: false
      timestamps()
    end

    create table(:subscriptions) do
      add :external_id, :string, null: false
      add :status, :string, null: false
      add :users_id, references(:users, on_delete: :delete_all), null: false
      add :plan_id, references(:plans), null: false
      timestamps()
    end
  end
end
