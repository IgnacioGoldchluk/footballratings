defmodule FootballratingsWeb.MatchLive.Search do
  defstruct [:home_team, :away_team, :before, :after, :available_for_rating, :league]

  @types %{
    home_team: :string,
    away_team: :string,
    before: :date,
    after: :date,
    available_for_rating: :boolean,
    league: :string
  }

  import Ecto.Changeset

  def changeset(%__MODULE__{} = search_opts, attrs) do
    {search_opts, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_length(:home_team, min: 3)
    |> validate_length(:away_team, min: 3)
  end
end
