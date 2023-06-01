defmodule Footballratings.FootballInfo.Match do
  use Ecto.Schema
  import Ecto.Changeset

  @match_status [
    # Time to be defined
    "TBD",
    # Not started
    "NS",
    # First half
    "1H",
    # Halftime
    "HT",
    # Second half
    "2H",
    # Extra time
    "ET",
    # Break time
    "BT",
    # Penalties
    "P",
    # Suspended
    "SUSP",
    # Interrupted
    "INT",
    # Finished
    "FT",
    # Finished after extra time
    "AET",
    # Finished after penalties
    "PEN",
    # Postponed
    "PST",
    # Technical loss
    "AWD",
    # WalkOver
    "WO",
    # In progress
    "LIVE"
  ]

  # Match is equivalent to fixture. The 3rd party provider uses "fixture"
  # but it is not commonly used in football nomenclature.
  schema "matches" do
    # Fields to identify the match in a certain time
    field :season, :integer
    field :timestamp, :integer
    field :round, :string

    # Score and final result
    field :goals_home, :integer
    field :goals_away, :integer
    field :penalties_home, :integer
    field :penalties_away, :integer
    field :status, :string

    belongs_to :league, Footballratings.FootballInfo.League
    belongs_to :home_team, Footballratings.FootballInfo.Team
    belongs_to :away_team, Footballratings.FootballInfo.Team

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
      :status,
      :league,
      :home_team,
      :away_team
    ])
    |> validate_required([
      :season,
      :timestamp,
      :round,
      :goals_home,
      :goals_away,
      :penalties_home,
      :penalties_away,
      :status,
      :league,
      :home_team,
      :away_team
    ])
  end
end
