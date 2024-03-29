defmodule Footballratings.FootballInfo.PlayerMatch do
  @moduledoc """
  Join table for every player present in a match.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "players_matches" do
    # minutes_played = nil means the player did not participate.
    field(:minutes_played, :integer)

    belongs_to(:match, Footballratings.FootballInfo.Match)
    belongs_to(:player, Footballratings.FootballInfo.Player)
    belongs_to(:team, Footballratings.FootballInfo.Team)

    timestamps()
  end

  def changeset(player_match, attrs) do
    player_match
    |> cast(attrs, [:match_id, :player_id, :team_id, :minutes_played])
    |> validate_required([:match_id, :player_id, :team_id, :minutes_played])
    |> validate_number(:minutes_played, greater_than: 0)
  end
end
