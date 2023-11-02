defmodule Footballratings.MercadoPagoTest do
  use Footballratings.DataCase

  import Mox
  alias Footballratings.MercadoPagoResponses

  alias Footballratings.MercadoPago

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
end
