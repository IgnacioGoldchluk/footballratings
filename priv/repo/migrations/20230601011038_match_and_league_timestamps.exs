defmodule Footballratings.Repo.Migrations.MatchAndLeagueTimestamps do
  use Ecto.Migration

  def change do
    alter table("leagues") do
      timestamps()
    end

    create table("matches") do
      add :season, :integer, null: false
      add :timestamp, :integer, null: false
      add :round, :string, null: false

      add :goals_home, :integer
      add :goals_away, :integer
      add :penalties_home, :integer
      add :penalties_away, :integer
      add :status, :string, null: false

      add :league, references("leagues"), null: false
      add :home_team, references("teams"), null: false
      add :away_team, references("teams"), null: false

      timestamps()
    end
  end
end
