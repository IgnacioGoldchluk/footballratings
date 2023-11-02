defmodule Footballratings.Workers.MatchesExpire do
  @moduledoc """
  Expires matches older than the specified days.

  The goal is to prevent users from rating outdated/irrelevant matches.
  """

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
