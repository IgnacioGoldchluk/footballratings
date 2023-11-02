defmodule Footballratings.Billing.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    field :external_id, :string
    field :status, Ecto.Enum, values: [:pending, :active, :cancelled, :paused]
    belongs_to :users, Footballratings.Accounts.Users
    belongs_to :plan, Footballratings.Billing.Plan, references: :external_id, type: :string

    timestamps()
  end

  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:external_id, :status, :plan_id, :users_id])
    |> foreign_key_constraint(:users_id)
    |> foreign_key_constraint(:plan_id)
    |> unique_constraint(:external_id)
  end
end
