defmodule Footballratings.MercadoPagoTest do
  use Footballratings.DataCase

  import Mox
  alias Footballratings.MercadoPagoResponses

  alias Footballratings.MercadoPago

  import Footballratings.AccountsFixtures
  import Footballratings.BillingFixtures

  describe "get_plan/1" do
    test "returns formatted plan when success" do
      stub(MercadoPagoClientMock, :request, fn
        :get, "/preapproval_plan/123456" -> MercadoPagoResponses.get_plan_mock_response()
      end)

      {:ok, plan} = MercadoPago.get_plan("123456")
      assert plan["external_id"] == "123456"
    end

    test "returns error tuple when invalid format" do
      stub(MercadoPagoClientMock, :request, fn
        :get, "/preapproval_plan/123456" ->
          {:ok, %Req.Response{body: %{"id" => "123456"}}}
      end)

      {:error, _} = MercadoPago.get_plan("123456")
    end
  end

  describe "get_subscription/1" do
    test "returns formatted subscription when success" do
      id = "2c938084726fca480172750000000000"
      endpoint = "/preapproval/#{id}"

      stub(MercadoPagoClientMock, :request, fn
        :get, ^endpoint -> MercadoPagoResponses.get_subscription_mock_response()
      end)

      {:ok, subscription} = MercadoPago.get_subscription(id)

      assert subscription["external_id"] == id
    end

    test "returns error tuple when invalid" do
      stub(MercadoPagoClientMock, :request, fn
        :get, "/preapproval/123" -> {:ok, %Req.Response{body: %{"id" => "123"}}}
      end)

      assert {:error, _} = MercadoPago.get_subscription("123")
    end
  end

  describe "create_subscription/1" do
    setup do
      %{user: users_fixture(), plan: plan_fixture()}
    end

    test "creates the subscription when params are valid", %{user: user, plan: plan} do
      stub(MercadoPagoClientMock, :request, fn
        :post, "/preapproval", _ -> MercadoPagoResponses.created_subscription()
      end)

      params = %{"token" => Ecto.UUID.generate(), "payer" => %{"email" => user.email}}

      assert {:ok, subscription} =
               MercadoPago.create_subscription(params, plan.external_id, user.id)

      assert subscription["user_id"] == user.id
    end

    test "returns error if payload is invalid", %{user: user, plan: plan} do
      stub(MercadoPagoClientMock, :request, fn
        :post, "/preapproval", _ -> MercadoPagoResponses.created_subscription()
      end)

      params = %{"token" => Ecto.UUID.generate(), "user_email" => user.email}

      assert {:error, _} = MercadoPago.create_subscription(params, plan.external_id, user.id)
    end

    test "returns error if the response is invalid", %{user: user, plan: plan} do
      stub(MercadoPagoClientMock, :request, fn
        :post, "/preapproval", _ -> {:ok, %Req.Response{body: %{"id" => "123"}}}
      end)

      params = %{"token" => Ecto.UUID.generate(), "payer" => %{"email" => user.email}}

      assert {:error, _} = MercadoPago.create_subscription(params, plan.id, user.id)
    end
  end
end
