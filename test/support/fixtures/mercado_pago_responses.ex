defmodule Footballratings.MercadoPagoResponses do
  def get_plan_mock_response() do
    {:ok,
     %Req.Response{
       status: 200,
       headers: %{},
       body: %{
         "application_id" => 123_456,
         "auto_recurring" => %{
           "billing_day" => 11,
           "billing_day_proportional" => false,
           "currency_id" => "ARS",
           "frequency" => 1,
           "frequency_type" => "months",
           "transaction_amount" => 399.0
         },
         "back_url" => "https://google.com",
         "collector_id" => 123_456,
         "date_created" => "2023-10-26T09:04:53.668-04:00",
         "external_reference" => "PLAN",
         "id" => "123456",
         "init_point" => "https://google.com",
         "last_modified" => "2023-10-31T15:26:16.122-04:00",
         "payment_methods_allowed" => %{},
         "reason" => "Test plans",
         "status" => "active"
       },
       trailers: %{},
       private: %{}
     }}
  end
end
