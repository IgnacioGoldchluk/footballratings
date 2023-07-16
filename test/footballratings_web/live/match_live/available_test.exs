defmodule FootballratingsWeb.MatchLive.AvailableTest do
  use FootballratingsWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Footballratings.InternalDataFixtures

  describe "available matches" do
    test "renders only available matches", %{conn: conn} do
      available_matches = for _ <- 1..6, do: InternalDataFixtures.create_match()
      expired_match = InternalDataFixtures.create_match(%{status: :expired})

      {:ok, view, _html} = live(conn, ~p"/available-matches")

      # Not all matches were loaded, we should see a load-more-matches-button
      assert has_element?(view, "#matches-table")
      assert has_element?(view, "#load-more-matches-button")

      # All matches loaded, button no longer available
      view |> element("#load-more-matches-button") |> render_click()
      refute has_element?(view, "#load-more-matches-button")

      # All available matches should exist
      assert Enum.all?(available_matches, fn %{id: match_id} ->
               has_element?(view, "#matches-#{match_id}")
             end)

      refute has_element?(view, "#matches-#{expired_match.id}")
    end
  end
end
