defmodule Footballratings.FootballInfo.Player do
  @moduledoc """
  Player information schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Footballratings.FootballInfo.Team

  schema "players" do
    field :name, :string
    field :firstname, :string
    field :lastname, :string
    field :age, :integer

    timestamps()

    belongs_to :team, Team
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :firstname, :lastname, :age, :id, :team_id])
    |> validate_required([:name, :id, :team_id])
    |> unique_constraint(:id)
  end
end
