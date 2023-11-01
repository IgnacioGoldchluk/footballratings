defmodule Footballratings.Billing.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plans" do
    field :external_id, :string
    field :frequency, :integer
    field :frequency_type, Ecto.Enum, values: [:days, :months, :years]
    field :amount, :integer
    field :currency, Ecto.Enum, values: [:ARS]
    field :status, Ecto.Enum, values: [:active, :cancelled]
    timestamps()
  end

  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:external_id, :frequency, :frequency_type, :amount, :currency, :status])
    |> validate_required([:external_id, :frequency, :frequency_type, :amount, :currency, :status])
    |> validate_number(:amount, greater_than: -1)
    |> validate_number(:frequency, greater_than: 0)
  end
end
