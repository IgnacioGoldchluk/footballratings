defmodule Footballratings.Repo.Migrations.RenameMinutesPlayer do
  use Ecto.Migration

  def change do
    rename table("players_matches"), :minutes_player, to: :minutes_played
  end
end
