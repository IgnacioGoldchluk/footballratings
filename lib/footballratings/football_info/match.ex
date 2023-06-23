defmodule Footballratings.FootballInfo.Match do
  @moduledoc """
  Match schema.
  """

  alias Footballratings.FootballInfo.PlayerMatch

  use Ecto.Schema
  import Ecto.Changeset

  # Match is equivalent to fixture. The 3rd party provider uses "fixture"
  # but it is not commonly used in football nomenclature.
  schema "matches" do
    # Fields to identify the match in a certain time
    field(:season, :integer)
    field(:timestamp, :integer)
    field(:round, :string)

    # Score and final result
    field(:goals_home, :integer)
    field(:goals_away, :integer)
    field(:penalties_home, :integer)
    field(:penalties_away, :integer)
    field(:status, Ecto.Enum, values: [:not_ready_yet, :ready, :expired])

    belongs_to(:league, Footballratings.FootballInfo.League)
    belongs_to(:home_team, Footballratings.FootballInfo.Team)
    belongs_to(:away_team, Footballratings.FootballInfo.Team)

    has_many(:players_matches, PlayerMatch)
    has_many(:players, through: [:players_matches, :player])

    timestamps()
  end

  def changeset(match, attrs) do
    match
    |> cast(attrs, [
      :season,
      :timestamp,
      :round,
      :goals_home,
      :goals_away,
      :penalties_home,
      :penalties_away,
      :league_id,
      :home_team_id,
      :away_team_id,
      :status,
      :id
    ])
    |> foreign_key_constraint(:league_id)
    |> foreign_key_constraint(:home_team_id)
    |> foreign_key_constraint(:away_team_id)
    |> validate_required([
      :season,
      :timestamp,
      :round,
      :goals_home,
      :goals_away,
      :status,
      :id
    ])
  end
end
