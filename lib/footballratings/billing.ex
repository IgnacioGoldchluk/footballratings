defmodule Footballratings.Billing do
  @moduledoc """
  The Billing context.

  Handles plans, subscriptions, etc.
  """
  alias Footballratings.Accounts
  alias Footballratings.MercadoPago
  alias Footballratings.Billing.{Plan, Subscription}
  alias Footballratings.Repo

  import Ecto.Query

  def get_plan_by_external_id(external_id) do
    Repo.get_by(Plan, external_id: external_id)
  end

  def get_subscription_by_external_id(external_id) do
    Repo.get_by(Subscription, external_id: external_id)
  end

  def create_plan(attrs) do
    %Plan{}
    |> Plan.changeset(attrs)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: :external_id)
  end

  def create_subscription(attrs) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end

  def update_subscription_status(external_id, status) when is_binary(status),
    do: update_subscription_status(external_id, String.to_existing_atom(status))

  def update_subscription_status(external_id, status) do
    get_subscription_by_external_id(external_id)
    |> Ecto.Changeset.change(status: status)
    |> Repo.update()
  end

  def latest_active_plan do
    Plan
    |> where([p], p.status == :active)
    |> order_by([p], desc: p.updated_at)
    |> first()
    |> Repo.one()
  end

  def create_subscription_from_checkout(%{"current_user_email" => user_email} = params) do
    with {:ok, recv_subscription} <- MercadoPago.create_subscription(params),
         {:ok, sub_data} <- link_user_to_subscription(recv_subscription, user_email),
         {:ok, subscription} <- create_subscription(sub_data) do
      {:ok, subscription}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp link_user_to_subscription(subscription, user_email) do
    case Accounts.get_users_by_email(user_email) do
      %Accounts.Users{id: id} -> {:ok, Map.put(subscription, "user_id", id)}
      nil -> {:error, "User not found for email #{user_email}"}
    end
  end
end
