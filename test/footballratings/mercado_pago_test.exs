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
  end
end
