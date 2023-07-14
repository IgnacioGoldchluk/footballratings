defmodule FootballratingsWeb.TeamLive.IndexTest do
  use FootballratingsWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Footballratings.InternalDataFixtures

  describe "index" do
    test "renders properly", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/teams")

      assert html =~ "Search team"
    end

    test "filters by team based on the input", %{conn: conn} do
      teams = ["Phoenix FC", "AC Nix"] |> Enum.map(&InternalDataFixtures.create_team(%{name: &1}))

      {:ok, view, html} = live(conn, ~p"/teams")

      refute Enum.any?(teams, fn team -> html =~ team.name end)

      assert view |> form("#search_team", %{"search[name]" => "pho"}) |> render_change() =~
               "Phoenix FC"

      rendered_nix = view |> form("#search_team", %{"search[name]" => "Nix"}) |> render_change()
      assert rendered_nix =~ "Phoenix FC"
      assert rendered_nix =~ "AC Nix"

      refute view |> form("#search_team", %{"search[name]" => ""}) |> render_change() =~
               "Phoenix FC"
    end
  end
end
