defmodule Footballratings.Billing do
  @moduledoc """
  The Billing context.

  Handles plans, subscriptions, etc.
  """
  alias Footballratings.Billing.{Plan, Subscription, TemporalSubscription}
  alias Footballratings.Repo

  import Ecto.Query

  def get_plan_by_external_id(external_id) do
    Repo.get_by(Plan, external_id: external_id)
  end

  def get_subscription_by_external_id(external_id) do
    Repo.get_by(Subscription, external_id: external_id)
  end

  def create_plan(attrs) do
    %Plan{}
    |> Plan.changeset(attrs)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: :external_id)
  end

  def create_subscription(attrs) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end

  def update_subscription_status(external_id, status) when is_binary(status),
    do: update_subscription_status(external_id, String.to_existing_atom(status))

  def update_subscription_status(external_id, status) do
    get_subscription_by_external_id(external_id)
    |> Ecto.Changeset.change(status: status)
    |> Repo.update()
  end

  def latest_active_plan do
    Plan
    |> where([p], p.status == :active)
    |> order_by([p], desc: p.updated_at)
    |> first()
    |> Repo.one()
  end

  def subscriptions_for_user(user_id) do
    Subscription
    |> where([s], s.users_id == ^user_id)
    |> order_by([s], desc: s.inserted_at)
    |> Repo.all()
  end

  def create_temporal_subscription(attrs) do
    %TemporalSubscription{}
    |> TemporalSubscription.changeset(attrs)
    |> Repo.insert()
  end

  def delete_temporal_subscriptions(user_id) do
    TemporalSubscription
    |> where([tp], tp.users_id == ^user_id)
    |> Repo.delete_all()
  end
end
