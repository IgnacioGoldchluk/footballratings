defmodule Footballratings.Billing.TemporalSubscription do
  @moduledoc """
  Store subscriptions that have been paid but not yet processed.

  This way a user can have access to paid features instantly after payment.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "temporal_subscriptions" do
    belongs_to :users, Footballratings.Accounts.Users
    belongs_to :plan, Footballratings.Billing.Plan, references: :external_id, type: :string

    timestamps()
  end

  def changeset(temporal_subscription, attrs) do
    temporal_subscription
    |> cast(attrs, [:plan_id, :users_id])
    |> foreign_key_constraint(:users_id)
    |> foreign_key_constraint(:plan_id)
  end
end
