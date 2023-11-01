defmodule Footballratings.Billing do
  alias Footballratings.Billing.{Plan, Subscription}
  alias Footballratings.Repo

  def get_plan_by_external_id(external_id) do
    Repo.get_by(Plan, external_id: external_id)
  end

  def get_subscription_by_external_id(external_id) do
    Repo.get_by(Subscription, external_id: external_id)
  end

  def create_plan(attrs) do
    %Plan{}
    |> Plan.changeset(attrs)
    |> Repo.insert()
  end

  def create_subscription(attrs) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end
end
