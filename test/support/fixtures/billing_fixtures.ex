defmodule Footballratings.BillingFixtures do
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
      plan_id: plan_fixture().id
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
end
