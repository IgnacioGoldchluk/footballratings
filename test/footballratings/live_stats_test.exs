defmodule Footballratings.LiveStatsTest do
  use Footballratings.DataCase

  @endpoint FootballratingsWeb.Endpoint

  describe "live stats" do
    test "returns the stats and publishes only when difference in stats" do
      Footballratings.InternalDataFixtures.create_match()
      Footballratings.AccountsFixtures.users_fixture()

      {:ok, pid} = GenServer.start_link(Footballratings.LiveStats, [])

      state = GenServer.call(pid, "live_stats")

      assert state == %{"matches" => 1, "users" => 1, "ratings" => 0}

      @endpoint.subscribe("live_stats")
      GenServer.cast(pid, :update_stats)
      :timer.sleep(10)
      refute_received(%{"matches" => 1, "users" => 1, "ratings" => 0})

      Footballratings.InternalDataFixtures.create_match()

      GenServer.cast(pid, :update_stats)
      :timer.sleep(10)
      assert_received(%{"matches" => 2, "users" => 1, "ratings" => 0})

      send(pid, :update)
      :timer.sleep(10)
      refute_received(%{"matches" => 2, "users" => 1, "ratings" => 0})
    end
  end
end
