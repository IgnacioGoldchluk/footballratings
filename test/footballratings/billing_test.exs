defmodule Footballratings.BillingTest do
  use Footballratings.DataCase
  alias Footballratings.Billing
  alias Footballratings.Billing.{Plan, Subscription, TemporalSubscription}
  import Footballratings.BillingFixtures
  import Footballratings.AccountsFixtures

  describe "get_plan_by_external_id/1" do
    test "returns plan if external_id exists" do
      %{external_id: id} = plan_fixture()

      assert %Plan{external_id: ^id} = Billing.get_plan_by_external_id(id)
    end

    test "returns nil if external_id does not exist" do
      assert nil == Billing.get_plan_by_external_id(Ecto.UUID.generate())
    end
  end

  describe "get_subscription_by_external_id/1" do
    test "returns subscription if external_id exists" do
      %{external_id: id} = subscription_fixture()

      assert %Subscription{external_id: ^id} = Billing.get_subscription_by_external_id(id)
    end

    test "returns nil if external_id does not exist" do
      assert nil == Billing.get_subscription_by_external_id(Ecto.UUID.generate())
    end
  end

  describe "create_subscription/1" do
    setup do
      %{
        valid_attrs: %{
          external_id: unique_external_id(),
          status: :active,
          users_id: Footballratings.AccountsFixtures.users_fixture().id,
          plan_id: plan_fixture().external_id
        }
      }
    end

    test "creates subscription with valid attributes", %{valid_attrs: attrs} do
      assert {:ok, subscription} = Billing.create_subscription(attrs)
      assert subscription.external_id == attrs[:external_id]
    end

    test "fails to create when status is invalid", %{valid_attrs: attrs} do
      attrs_1 = Map.put(attrs, :status, "Not A Valid Status")
      assert {:error, _} = Billing.create_subscription(attrs_1)
    end

    test "fails if external_id is duplicated", %{valid_attrs: attrs} do
      {:ok, %Subscription{}} = Billing.create_subscription(attrs)
      assert {:error, _} = Billing.create_subscription(attrs)
    end
  end

  describe "create_plan/1" do
    setup do
      %{
        valid_attrs: %{
          external_id: unique_external_id(),
          frequency: 1,
          frequency_type: "days",
          amount: 123,
          currency: "ARS",
          status: "active"
        }
      }
    end

    test "creates plan with valid attributes", %{valid_attrs: attrs} do
      {:ok, plan} = Billing.create_plan(attrs)
      assert plan.external_id == attrs[:external_id]
    end

    test "validate amount and frequency", %{valid_attrs: attrs} do
      attrs_1 = Map.put(attrs, :frequency, -1)
      assert {:error, _} = Billing.create_plan(attrs_1)

      attrs_2 = Map.put(attrs, :amount, -1)
      assert {:error, _} = Billing.create_plan(attrs_2)
    end

    test "validates frequency, currency and status types", %{valid_attrs: attrs} do
      attrs_1 = Map.put(attrs, :frequency_type, "invalid")
      assert {:error, _} = Billing.create_plan(attrs_1)

      attrs_2 = Map.put(attrs, :currency, "PESOS")
      assert {:error, _} = Billing.create_plan(attrs_2)

      attrs_3 = Map.put(attrs, :status, "Invalid")
      assert {:error, _} = Billing.create_plan(attrs_3)
    end

    test "replaces existing values", %{valid_attrs: attrs} do
      {:ok, _} = Billing.create_plan(attrs)

      # Increase price by 100
      new_attrs = Map.update!(attrs, :amount, fn amount -> amount + 100 end)

      {:ok, plan} = Billing.create_plan(new_attrs)

      assert plan.amount == attrs[:amount] + 100
    end
  end

  describe "update_subscription_status/2" do
    setup do
      %{subscription: subscription_fixture()}
    end

    test "updates if subscription is valid", %{subscription: subscription} do
      id = subscription.external_id
      new_status = "cancelled"

      assert {:ok, updated_sub} = Billing.update_subscription_status(id, new_status)

      assert updated_sub.status == :cancelled
      assert updated_sub.external_id == id

      assert {:ok, updated_sub} = Billing.update_subscription_status(id, :active)
      assert updated_sub.status == :active
      assert updated_sub.external_id == id
    end
  end

  describe "latest_active_plan/1" do
    test "returns the latest active plan" do
      p1 = plan_fixture(%{status: :active})
      _p2 = plan_fixture(%{status: :cancelled})

      plan = Billing.latest_active_plan()
      assert plan.external_id == p1.external_id
    end
  end

  describe "subscriptions_for_user/1" do
    setup do
      %{user: users_fixture()}
    end

    test "returns empty when no subscriptions", %{user: user} do
      assert Enum.empty?(Billing.subscriptions_for_user(user.id))
    end

    test "returns subscriptions sorted by date", %{user: user} do
      sub1 = subscription_fixture(%{users_id: user.id})

      assert [sub] = Billing.subscriptions_for_user(user.id)

      assert sub1.external_id == sub.external_id
    end
  end

  describe "create_temporal_subscription/1" do
    setup do
      %{user: users_fixture(), plan: plan_fixture()}
    end

    test "creates if both user and plan exist", %{user: u, plan: p} do
      assert {:ok, %TemporalSubscription{} = subscription} =
               Billing.create_temporal_subscription(%{users_id: u.id, plan_id: p.external_id})

      assert subscription.plan_id == p.external_id
      assert subscription.users_id == u.id
    end

    test "fails if either plan or user are invalid", %{user: u, plan: p} do
      invalid_user_attrs = %{users_id: System.unique_integer([:positive]), plan_id: p.external_id}
      assert {:error, _} = Billing.create_temporal_subscription(invalid_user_attrs)

      invalid_plan_attrs = %{users_id: u.id, plan_id: Ecto.UUID.generate()}
      assert {:error, _} = Billing.create_temporal_subscription(invalid_plan_attrs)
    end
  end

  describe "delete_temporal_subscriptions/1" do
    test "deletes only for the specified user" do
      ts1 = temporal_subscription_fixture()
      ts2 = temporal_subscription_fixture()

      assert ts1.users_id != ts2.users_id

      {deleted, _} = Billing.delete_temporal_subscriptions(ts1.users_id)
      assert deleted == 1
    end
  end
end
