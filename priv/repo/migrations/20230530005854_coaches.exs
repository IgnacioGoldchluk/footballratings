defmodule Footballratings.Repo.Migrations.Coaches do
  use Ecto.Migration

  def change do
    create table("coaches") do
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
