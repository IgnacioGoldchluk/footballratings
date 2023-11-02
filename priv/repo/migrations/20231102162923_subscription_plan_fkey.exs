defmodule Footballratings.Repo.Migrations.SubscriptionPlanFkey do
  use Ecto.Migration

  def change do
    alter table(:subscriptions) do
      remove :plan_id
    end

    alter table(:subscriptions) do
      add :plan_id, references(:plans, column: :external_id, type: :string), null: false
    end
  end
end
