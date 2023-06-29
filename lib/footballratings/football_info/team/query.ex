defmodule Footballratings.FootballInfo.Team.Query do
  import Ecto.Query
  alias Footballratings.FootballInfo.Team

  def base() do
    Team
    |> order_by([t], asc: t.name)
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
