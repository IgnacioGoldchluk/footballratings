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

  def for_home_team_ilike(query, ""), do: query

  def for_home_team_ilike(query, team_name) do
    ht_name = "%#{team_name}%"

    query
    |> where([m, ht, at, l], ilike(ht.name, ^ht_name))
  end

  def for_away_team_ilike(query, ""), do: query

  def for_away_team_ilike(query, team_name) do
    at_name = "%#{team_name}%"

    query
    |> where([m, ht, at, l], ilike(at.name, ^at_name))
  end

  def available_for_rating(query \\ preload_all_match_data()) do
    query
    |> where([m], m.status == :ready)
  end

  def before_date(query, ""), do: query

  def before_date(query, date) do
    # For before we want "00:00" to filter the lowest value
    date_timestamp = date_to_unix(date, "00:00:00")

    query
    |> where([m], m.timestamp <= ^date_timestamp)
  end

  def after_date(query, ""), do: query

  def after_date(query, date) do
    # For after, we want "23:59" to cover the highest value
    date_timestamp = date_to_unix(date, "23:59:59")

    query
    |> where([m], m.timestamp >= ^date_timestamp)
  end

  def for_search_params(%{
        "home_team" => ht,
        "away_team" => at,
        "before" => bd,
        "after" => ad,
        "available_for_rating" => for_rating
      }) do
    preload_all_match_data()
    |> for_home_team_ilike(ht)
    |> for_away_team_ilike(at)
    |> before_date(bd)
    |> after_date(ad)
    |> order_by([m], desc: m.timestamp)
    |> then(fn query ->
      if for_rating == "true" do
        query |> available_for_rating()
      else
        query
      end
    end)
  end

  defp date_to_unix(date, hour) do
    "#{date}T#{hour}+00:00"
    |> DateTime.from_iso8601()
    |> elem(1)
    |> DateTime.to_unix()
  end
end
