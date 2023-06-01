defmodule Footballratings.FootballInfo.League do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leagues" do
    field :name, :string

    timestamps()
  end

  def changeset(league, attrs) do
    league
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
