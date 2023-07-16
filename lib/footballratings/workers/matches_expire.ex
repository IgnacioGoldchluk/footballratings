defmodule Footballratings.Workers.MatchesExpire do
  use Oban.Worker, queue: :default

  alias Footballratings.FootballInfo

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"days" => days}}) do
    DateTime.utc_now()
    |> DateTime.add(-days, :day)
    |> DateTime.to_unix()
    |> FootballInfo.expire_matches()

    :ok
  end
end
