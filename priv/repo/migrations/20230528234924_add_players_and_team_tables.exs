defmodule Footballratings.Repo.Migrations.AddPlayersAndTeamTables do
  use Ecto.Migration

  def change do
    create table("teams") do
      add :code, :string, null: false
      add :country, :string, null: false
      add :founded, :integer, null: false
      add :logo, :string, null: false
      add :name, :string, null: false
      add :national, :boolean, null: false
      timestamps()
    end

    create table("players") do
      add :name, :string, null: false
      add :firstname, :string
      add :lastname, :string
      add :age, :integer
      add :photo, :string
      add :team_id, references("teams"), null: false
      timestamps()
    end
  end
end
