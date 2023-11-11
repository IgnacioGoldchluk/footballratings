defmodule Footballratings.BillingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Footballratings.Billing` context.
  """

  def unique_external_id(), do: Ecto.UUID.generate()

  def valid_plan_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      external_id: unique_external_id(),
      frequency: 1,
      frequency_type: :months,
      amount: 999,
      currency: :ARS,
      status: :active
    })
  end

  def valid_subscription_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      external_id: unique_external_id(),
      status: :active,
      users_id: Footballratings.AccountsFixtures.users_fixture().id,
      plan_id: plan_fixture().external_id
    })
  end

  def valid_temporal_subscription_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      plan_id: plan_fixture().external_id,
      users_id: Footballratings.AccountsFixtures.users_fixture().id
    })
  end

  def plan_fixture(attrs \\ %{}) do
    {:ok, plan} =
      attrs
      |> valid_plan_attributes()
      |> Footballratings.Billing.create_plan()

    plan
  end

  def subscription_fixture(attrs \\ %{}) do
    {:ok, subscription} =
      attrs
      |> valid_subscription_attributes()
      |> Footballratings.Billing.create_subscription()

    subscription
  end

  def temporal_subscription_fixture(attrs \\ %{}) do
    {:ok, temporal_subscription} =
      attrs
      |> valid_temporal_subscription_attributes()
      |> Footballratings.Billing.create_temporal_subscription()

    temporal_subscription
  end
end
