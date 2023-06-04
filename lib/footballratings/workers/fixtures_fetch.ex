defmodule Footballratings.Workers.FixturesFetch do
  use Oban.Worker, queue: :default

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => league_id, "season" => season}}) do
    today = Date.utc_today()
    yesterday = Date.add(today, -1)
    {:ok, response} = FootballApi.matches(league_id, season, yesterday, today)

    response
    |> Enum.filter(&FootballApi.Processing.Match.match_finished?/1)
    |> Enum.map(&FootballApi.Processing.Match.to_internal_match_schema/1)

    IO.inspect(response)
  end
end
