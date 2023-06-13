defmodule Footballratings.Workers.MatchesExpire do
  use Oban.Worker, queue: :default

  alias Footballratings.FootballInfo.Match

  import Ecto.Query

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    now = DateTime.utc_now() |> DateTime.to_unix()
    seconds_in_a_week = 604_800

    a_week_ago = now - seconds_in_a_week
    matches_older_than_one_week = from(m in Match, where: m.timestamp < ^a_week_ago)

    Footballratings.Repo.update_all(matches_older_than_one_week,
      set: [status: :expired]
    )

    :ok
  end
end
