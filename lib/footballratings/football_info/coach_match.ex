defmodule Footballratings.FootballInfo.CoachMatch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "coaches_matches" do
    belongs_to(:match, Footballratings.FootballInfo.Match)
    belongs_to(:coach, Footballratings.FootballInfo.Coach)
    belongs_to(:team, Footballratings.FootballInfo.Team)

    timestamps()
  end

  def changeset(coach_match, attrs) do
    coach_match
    |> cast(attrs, [:match_id, :coach_id, :team_id])
    |> validate_required([:match_id, :coach_id, :team_id])
  end
end
