defmodule Footballratings.Repo.Migrations.FixRelations do
  use Ecto.Migration

  def change do
    rename(table("matches"), :league, to: :league_id)
    rename(table("matches"), :home_team, to: :home_team_id)
    rename(table("matches"), :away_team, to: :away_team_id)
    rename(table("players_matches"), :match, to: :match_id)
    rename(table("players_matches"), :player, to: :player_id)
    rename(table("players_matches"), :team, to: :team_id)
    rename(table("coaches_matches"), :match, to: :match_id)
    rename(table("coaches_matches"), :coach, to: :coach_id)
    rename(table("coaches_matches"), :team, to: :team_id)
  end
end
