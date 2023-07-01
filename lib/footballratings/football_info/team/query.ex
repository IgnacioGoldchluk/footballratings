defmodule Footballratings.FootballInfo.Team.Query do
  import Ecto.Query
  alias Footballratings.FootballInfo.Team

  def base() do
    Team
    |> order_by([t], asc: t.name)
  end

  def for_team_id(query \\ base(), team_id) do
    query
    |> where([t], t.id == ^team_id)
  end

  def current_players(query) do
    query
    |> join(:left, [t], p in assoc(t, :players))
    |> preload([t, p], players: p)
  end

  def for_name_ilike(query, ""), do: query

  def for_name_ilike(query, name) do
    name_string = "%#{name}%"

    query
    |> where([t], ilike(t.name, ^name_string))
  end

  def for_search_params(%{"name" => partial_name}) do
    base()
    |> for_name_ilike(partial_name)
  end
end
