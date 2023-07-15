defmodule FootballratingsWeb.TeamLive.PlayersTest do
  use FootballratingsWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Footballratings.InternalDataFixtures

  setup do
    %{team: InternalDataFixtures.create_team()}
  end

  describe "team players" do
    test "renders with team name and back to team link", %{conn: conn, team: team} do
      %{id: team_id, name: team_name} = team

      {:ok, view, html} = live(conn, ~p"/teams/#{team_id}/players")

      assert html =~ team_name
      assert html =~ "Back to team"

      view |> element("#back-to-team-link") |> render_click()
      path = assert_patch(view)
      assert path =~ "/teams/#{team_id}"
    end

    test "all players are shown by default", %{conn: conn, team: team} do
      %{id: team_id} = team
      players = for _ <- 1..11, do: InternalDataFixtures.create_player(%{team_id: team_id})

      {:ok, _view, html} = live(conn, ~p"/teams/#{team_id}/players")

      assert Enum.all?(players, fn %{name: player_name} ->
               html =~ player_name
             end)
    end

    test "filters players by name", %{conn: conn, team: team} do
      %{id: team_id} = team
      p1 = InternalDataFixtures.create_player(%{team_id: team_id, name: "Erlang"})
      p2 = InternalDataFixtures.create_player(%{team_id: team_id, name: "Angus"})

      %{id: t2_id} = InternalDataFixtures.create_team()
      p3 = InternalDataFixtures.create_player(%{team_id: t2_id, name: "Erling"})

      {:ok, view, html} = live(conn, ~p"/teams/#{team_id}/players")
      assert html =~ p1.name
      assert html =~ p2.name
      refute html =~ p3.name

      new_html = view |> form("#search_player", %{"search[name]" => "erl"}) |> render_change()
      assert new_html =~ p1.name
      refute new_html =~ p2.name
      refute new_html =~ p3.name
    end
  end
end
