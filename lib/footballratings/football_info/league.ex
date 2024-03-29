defmodule Footballratings.FootballInfo.League do
  @moduledoc """
  League schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "leagues" do
    field(:name, Footballratings.AsciiString)
    field(:season, :integer)

    timestamps()
  end

  def changeset(league, attrs) do
    league
    |> cast(attrs, [:name, :season, :id])
    |> validate_required([:season, :id, :name])
  end
end
