defmodule Footballratings.FootballInfo.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias Footballratings.FootballInfo.Player

  schema "teams" do
    field :code, :string
    field :country, :string
    field :founded, :integer
    field :name, :string
    field :national, :boolean

    has_many :players, Player

    timestamps()
  end

  def changeset(team, attrs) do
    team
    |> cast(attrs, [:code, :country, :founded, :name, :national, :id])
    |> validate_required([:code, :country, :founded, :name, :national, :id])
    |> unique_constraint(:id)
  end
end
