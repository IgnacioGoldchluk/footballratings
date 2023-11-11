defmodule Footballratings.Billing.Subscription do
  @moduledoc """
  Subscriptions of plans for users.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    field :external_id, :string

    field :status, Ecto.Enum,
      values: [
        :on_trial,
        :active,
        :paused,
        :past_due,
        :unpaid,
        :cancelled,
        :expired
      ]

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
