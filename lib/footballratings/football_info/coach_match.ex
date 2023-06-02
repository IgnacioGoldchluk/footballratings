defmodule Footballratings.FootballInfo.CoachMatch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "coaches_matches" do
    belongs_to :match, Footballratings.FootballInfo.Match
    belongs_to :coach, Footballratings.FootballInfo.Coach
    belongs_to :team, Footballratings.FootballInfo.Team

    timestamps()
  end

  def changeset(coach_match, attrs) do
    coach_match
    |> cast(attrs, [:match, :coach, :team])
    |> validate_required([:match, :coach, :team])
  end
end
