defmodule Footballratings.FootballInfo.Player do
  @moduledoc """
  Player information schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Footballratings.FootballInfo.{Team, PlayerMatch}

  schema "players" do
    field :name, Footballratings.AsciiString
    field :firstname, Footballratings.AsciiString
    field :lastname, Footballratings.AsciiString
    field :age, :integer

    timestamps()

    belongs_to :team, Team
    has_many :player_matches, PlayerMatch
    has_many :teams, through: [:player_matches, :team]

    many_to_many :matches, Footballratings.FootballInfo.Match,
      join_through: Footballratings.FootballInfo.PlayerMatch
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :firstname, :lastname, :age, :id, :team_id])
    |> validate_required([:name, :id, :team_id])
    |> unique_constraint(:id)
  end
end
