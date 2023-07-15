defmodule FootballratingsWeb.MatchLive.ShowTest do
  use FootballratingsWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Footballratings.InternalDataFixtures

  setup do
    %{id: league_id} = l = InternalDataFixtures.create_league(%{name: "First League"})
    %{id: t1_id} = t1 = InternalDataFixtures.create_team(%{name: "Home FC"})
    %{id: t2_id} = t2 = InternalDataFixtures.create_team(%{name: "Away FC"})

    %{
      match:
        InternalDataFixtures.create_match(%{
          league_id: league_id,
          home_team_id: t1_id,
          away_team_id: t2_id
        }),
      home_team: t1,
      away_team: t2,
      league: l
    }
  end

  describe "Main page for a match" do
    test "displays league, home and away teams", %{
      conn: conn,
      match: match,
      league: l,
      home_team: ht,
      away_team: at
    } do
      {:ok, _view, html} = live(conn, ~p"/matches/#{match.id}")

      assert html =~ l.name
      assert html =~ ht.name
      assert html =~ at.name
    end

    test "contains a ratings statistics link", %{conn: conn, match: match} do
      {:ok, view, html} = live(conn, ~p"/matches/#{match.id}")

      assert html =~ "Ratings Statistics"
      view |> element("#ratings-statistics-link") |> render_click()
      path = assert_patch(view)
      assert path =~ "/matches/#{match.id}/statistics"
    end

    test "contains links for home and away team if match is ready", %{
      conn: conn,
      match: match,
      home_team: ht,
      away_team: at
    } do
      {:ok, view, _html} = live(conn, ~p"/matches/#{match.id}")

      assert has_element?(view, "#rate-home-team")
      assert has_element?(view, "#rate-away-team")

      {:ok, match} =
        match
        |> Ecto.Changeset.change(status: :expired)
        |> Footballratings.Repo.update()

      {:ok, view, html} = live(conn, ~p"/matches/#{match.id}")
      refute has_element?(view, "#rate-home-team")
      refute has_element?(view, "#rate-away-team")
      assert html =~ ht.name
      assert html =~ at.name
    end
  end
end
