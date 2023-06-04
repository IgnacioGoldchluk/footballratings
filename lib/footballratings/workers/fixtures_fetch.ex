defmodule Footballratings.Workers.FixturesFetch do
  use Oban.Worker, queue: :default

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => league_id, "season" => season}}) do
    today = Date.utc_today()
    yesterday = Date.add(today, -1)
    {:ok, response} = FootballApi.matches(league_id, season, yesterday, today)

    %{teams: %{home: home_team, away: away_team}, league: league} = response

    # match =
    #   response
    #   |> Enum.filter(&FootballApi.Processing.Match.match_finished?/1)
    #   |> Enum.map(&FootballApi.Processing.Match.to_internal_match_schema/1)

    home_team = FootballApi.Processing.Team.to_internal_team_schema(home_team)
    away_team = FootballApi.Processing.Team.to_internal_team_schema(away_team)
    Footballratings.FootballInfo.maybe_create_team(home_team)
    Footballratings.FootballInfo.maybe_create_team(away_team)

    league = FootballApi.Processing.League.to_internal_league_schema(league)
    Footballratings.FootballInfo.maybe_create_league(league)

    :ok
  end
end
