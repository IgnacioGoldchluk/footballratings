defmodule Footballratings.Repo.Migrations.PlayerMatchAndCoachMatch do
  use Ecto.Migration

  def change do
    create table("players_matches") do
      add :minutes_player, :integer, null: false
      add :match, references("matches"), null: false
      add :player, references("players"), null: false
      add :team, references("teams"), null: false
      timestamps()
    end

    create table("coaches_matches") do
      add :match, references("matches"), null: false
      add :coach, references("coaches"), null: false
      add :team, references("teams"), null: false
      timestamps()
    end
  end
end
