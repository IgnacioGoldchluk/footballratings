defmodule Footballratings.MercadoPago.WebhookHandlerTest do
  use Footballratings.DataCase
  use Oban.Testing, repo: Footballratings.Repo

  alias Footballratings.MercadoPago.WebhookHandler
  alias Footballratings.MercadoPago.Workers
  import Mox
  alias Footballratings.MercadoPagoResponses

  describe "handle/1" do
    test "handles plan creation" do
      stub(MercadoPagoClientMock, :request, fn
        :get, "/preapproval_plan/123456" -> MercadoPagoResponses.get_plan_mock_response()
      end)

      req = %{"type" => "subscription_preapproval_plan", "data" => %{"id" => "123456"}}
      assert :ok = WebhookHandler.handle(req)
      assert nil != Footballratings.Billing.get_plan_by_external_id("123456")
    end
  end
end
