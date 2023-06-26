defmodule Footballratings.FootballInfo.Match.Query do
  import Ecto.Query

  alias Footballratings.FootballInfo.{Match}

  def base() do
    Match
  end

  def preload_all_match_data(query \\ base()) do
    query
    |> join(:left, [m], ht in assoc(m, :home_team))
    |> join(:left, [m], at in assoc(m, :away_team))
    |> join(:left, [m], l in assoc(m, :league))
    |> preload([m, ht, at, l], home_team: ht, away_team: at, league: l)
  end

  def for_home_team_ilike(query \\ preload_all_match_data(), team_name) do
    ht_name = "%#{team_name}%"

    query
    |> where([m, ht, at, l], ilike(ht, ^ht_name))
  end

  def for_away_team_ilike(query \\ preload_all_match_data(), team_name) do
    at_name = "%#{team_name}%"

    query
    |> where([m, ht, at, l], ilike(at, ^at_name))
  end

  def available_for_rating(query \\ preload_all_match_data()) do
    query
    |> where([m], m.status == :ready)
  end

  def before_date(query, date) do
    date_timestamp = DateTime.to_unix(date)

    query
    |> where([m], m.timestamp < ^date_timestamp)
  end

  def after_date(query, date) do
    date_timestamp = DateTime.to_unix(date)

    query
    |> where([m], m.timestamp > ^date_timestamp)
  end
end
