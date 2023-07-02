defmodule Footballratings.Repo.Migrations.UniquePlayerMatch do
  use Ecto.Migration

  def change do
    create unique_index("players_matches", [:match_id, :team_id, :player_id])
  end
end
