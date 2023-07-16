defmodule FootballratingsWeb.PlayerLive.IndexTest do
  alias Footballratings.InternalDataFixtures
  use FootballratingsWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "players index" do
    test "renders home page", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/players")

      assert html =~ "Search player"
      assert view |> has_element?("#players-table")
    end

    test "returns players for search parameters", %{conn: conn} do
      %{id: tid} = InternalDataFixtures.create_team()
      p1 = InternalDataFixtures.create_player(%{name: "Di Placido", team_id: tid})
      p2 = InternalDataFixtures.create_player(%{name: "Jose Lopez", team_id: tid})

      {:ok, view, html} = live(conn, ~p"/players")

      refute Enum.any?([p1, p2], fn %{name: p_name} -> html =~ p_name end)

      new_html = view |> form("#search_player", %{search: %{name: "acid"}}) |> render_change()

      assert new_html =~ p1.name
      refute new_html =~ p2.name

      assert view |> has_element?("#players-#{p1.id}")
    end
  end
end
