defmodule Footballratings.FootballInfo.Player.Query do
  @moduledoc """
  Query utilities for Player records.
  """
  import Ecto.Query
  alias Footballratings.FootballInfo.Player

  def base() do
    Player
    |> order_by([p], asc: p.name)
  end

  def for_name_ilike(query, ""), do: query

  def for_name_ilike(query, name) do
    name_string = "%#{name}%"

    query
    |> where([p], ilike(p.name, ^name_string))
  end

  def for_search_params(%{"name" => partial_name}) do
    base()
    |> for_name_ilike(partial_name)
  end
end
