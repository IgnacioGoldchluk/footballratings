defmodule FootballratingsWeb.StatsLiveTest do
  use FootballratingsWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "stats_live_component" do
    test "renders with default values" do
      component =
        render_component(FootballratingsWeb.StatsLive, users: 12, matches: 34, ratings: 56)

      assert component =~ "12"
      assert component =~ "34"
      assert component =~ "56"
      assert component =~ "Total registered users"
      assert component =~ "Matches available"
      assert component =~ "Unique ratings"
    end
  end
end
