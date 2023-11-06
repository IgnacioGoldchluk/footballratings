defmodule Footballratings.MercadoPago do
  @moduledoc """
  Interface with MercadoPago
  """
  alias Footballratings.MercadoPago
  alias Footballratings.MercadoPago.Parser

  defp api_client(),
    do: Application.get_env(:footballratings, :mercado_pago_client, MercadoPago.Client)

  def get_plan(id) do
    endpoint = "/preapproval_plan/#{id}"

    with {:ok, %Req.Response{body: body}} <- api_client().request(:get, endpoint),
         {:ok, plan} <- Parser.parse_plan(body) do
      {:ok, plan}
    else
      {:error, exception} -> {:error, exception}
    end
  end

  def get_subscription(id) do
    endpoint = "/preapproval/#{id}"

    with {:ok, %Req.Response{body: body}} <- api_client().request(:get, endpoint),
         {:ok, subscription} <- Parser.parse_subscription(body) do
      {:ok, subscription}
    else
      {:error, exception} -> {:error, exception}
    end
  end

  def create_subscription(params, plan_id, user_id) do
    with {:ok, sub} <- Parser.create_subscription(params, plan_id),
         {:ok, %Req.Response{body: body}} <-
           api_client().request(:post, "/preapproval", sub |> Jason.encode!()),
         {:ok, parsed_response} <- Parser.created_subscription(body),
         {:ok, subscription_with_user} <-
           Parser.add_user_to_subscription(parsed_response, user_id) do
      {:ok, subscription_with_user}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
