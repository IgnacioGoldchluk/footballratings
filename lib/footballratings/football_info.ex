defmodule Footballratings.FootballInfo do
  alias Footballratings.Repo
  alias Footballratings.FootballInfo.Team

  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end
end
