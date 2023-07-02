defmodule Footballratings.FootballInfo.Team do
  @moduledoc """
  Team schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Footballratings.FootballInfo.Player

  schema "teams" do
    field(:name, Footballratings.AsciiString)
    has_many(:players, Player)

    timestamps()
  end

  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :id])
    |> validate_required([:name, :id])
  end
end
