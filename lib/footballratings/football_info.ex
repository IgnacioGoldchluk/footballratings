defmodule Footballratings.FootballInfo do
  alias Footballratings.Repo
  alias Footballratings.FootballInfo.{Team, League}

  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def maybe_create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert!(on_conflict: :nothing)
  end

  def maybe_create_league(attrs \\ %{}) do
    %League{}
    |> League.changeset(attrs)
    |> Repo.insert!(on_conflict: :nothing)
  end
end
