defmodule FootballratingsWeb.RatingLive.UsersTest do
  alias Footballratings.RatingsFixtures
  alias Footballratings.AccountsFixtures
  alias Footballratings.InternalDataFixtures
  use FootballratingsWeb.ConnCase
  import Phoenix.LiveViewTest

  setup do
    m1 = %{home_team_id: m1_htid} = InternalDataFixtures.create_match()
    m2 = %{away_team_id: m2_atid} = InternalDataFixtures.create_match()

    user = AccountsFixtures.users_fixture()

    mr1 =
      RatingsFixtures.create_match_ratings(%{match_id: m1.id, users_id: user.id, team_id: m1_htid})

    mr2 =
      RatingsFixtures.create_match_ratings(%{match_id: m2.id, users_id: user.id, team_id: m2_atid})

    %{user: user, match_ratings: [mr1, mr2]}
  end

  describe "ratings by user" do
    test "displays the match ratings", %{conn: conn, user: user, match_ratings: mrs} do
      {:ok, view, html} = live(conn, ~p"/ratings/users/#{user.id}")

      assert html =~ user.username
      assert has_element?(view, "#match-ratings")
      assert Enum.all?(mrs, fn %{id: mr_id} -> has_element?(view, "#match_ratings-#{mr_id}") end)
    end

    test "contains a load more", %{conn: conn, user: user} do
      more_mrs = for _ <- 1..3, do: RatingsFixtures.create_match_ratings(%{users_id: user.id})

      {:ok, view, html} = live(conn, ~p"/ratings/users/#{user.id}")

      assert html =~ "Load More"

      refute Enum.all?(more_mrs, fn %{id: mr_id} ->
               has_element?(view, "#match_ratings-#{mr_id}")
             end)

      view |> element("#load-more-matches-ratings-button") |> render_click()

      assert Enum.all?(more_mrs, fn %{id: mr_id} ->
               has_element?(view, "#match_ratings-#{mr_id}")
             end)

      refute view |> has_element?("#load-more-matches-ratings-button")
    end
  end
end
