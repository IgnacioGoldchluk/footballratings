defmodule Footballratings.Workers.MatchesExpireTest do
  use Footballratings.DataCase
  use Oban.Testing, repo: Repo

  alias Footballratings.FootballInfo.Match

  import Footballratings.InternalDataFixtures

  describe "matches_expire" do
    test "match newer than one week is not expired" do
      now = DateTime.utc_now() |> DateTime.to_unix()
      three_days_in_seconds = 3 * 24 * 60 * 60
      three_days_ago = now - three_days_in_seconds
      match = create_match(%{status: :ready, timestamp: three_days_ago})

      :ok = perform_job(Footballratings.Workers.MatchesExpire, %{"days" => 7})

      queried_match = Repo.get(Match, match.id)
      assert queried_match.status == :ready
    end

    test "match older than a week is expired" do
      now = DateTime.utc_now() |> DateTime.to_unix()
      ten_days_in_seconds = 10 * 24 * 60 * 60
      ten_days_ago = now - ten_days_in_seconds
      match = create_match(%{status: :ready, timestamp: ten_days_ago})

      :ok = perform_job(Footballratings.Workers.MatchesExpire, %{"days" => 7})
      queried_match = Repo.get(Match, match.id)
      assert queried_match.status == :expired
    end
  end
end
