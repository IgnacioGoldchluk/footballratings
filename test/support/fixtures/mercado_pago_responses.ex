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

  def get_subscription_mock_response() do
    {:ok,
     %Req.Response{
       status: 200,
       headers: %{},
       body: %{
         "id" => "2c938084726fca480172750000000000",
         "version" => 0,
         "application_id" => 1_234_567_812_345_678,
         "collector_id" => 100_200_300,
         "preapproval_plan_id" => "2c938084726fca480172750000000000",
         "reason" => "Yoga classes.",
         "external_reference" => 23_546_246_234,
         "back_url" => "https://www.mercadopago.com.ar",
         "init_point" =>
           "https://www.mercadopago.com.ar/subscriptions/checkout?preapproval_id=2c938084726fca480172750000000000",
         "auto_recurring" => %{
           "frequency" => 1,
           "frequency_type" => "months",
           "start_date" => "2020-06-02T13:07:14.260Z",
           "end_date" => "2022-07-20T15:59:52.581Z",
           "currency_id" => "ARS",
           "transaction_amount" => 10,
           "free_trial" => %{
             "frequency" => 1,
             "frequency_type" => "months"
           }
         },
         "first_invoice_offset" => 7,
         "payer_id" => 123_123_123,
         "card_id" => 123_123_123,
         "payment_method_id" => "account_money",
         "next_payment_date" => "2022-01-01T11:12:25.892-04:00",
         "date_created" => "2022-01-01T11:12:25.892-04:00",
         "last_modified" => "2022-01-01T11:12:25.892-04:00",
         "summarized" => %{
           "quotas" => 6,
           "charged_quantity" => 3,
           "charged_amount" => 1000,
           "pending_charge_quantity" => 1,
           "pending_charge_amount" => 200,
           "last_charged_date" => "2022-01-01T11:12:25.892-04:00",
           "last_charged_amount" => 100,
           "semaphore" => "green"
         },
         "status" => "pending"
       },
       trailers: %{},
       private: %{}
     }}
  end
end
