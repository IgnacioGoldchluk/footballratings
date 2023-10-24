defmodule FootballratingsWeb.MatchLive.RateTest do
  alias Footballratings.AccountsFixtures
  alias Footballratings.InternalDataFixtures
  use FootballratingsWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Footballratings.Ratings

  setup do
    team = %{id: tid} = InternalDataFixtures.create_team(%{name: "Palmeiras"})
    match = %{id: mid} = InternalDataFixtures.create_match(%{home_team_id: tid})

    players =
      ["Jose Lopez", "Endrick", "Gustavo Gomez"]
      |> Enum.map(&InternalDataFixtures.create_player(%{name: &1, team_id: tid}))

    players
    |> Enum.each(
      &InternalDataFixtures.create_player_match(%{match_id: mid, team_id: tid, player_id: &1.id})
    )

    users = AccountsFixtures.users_fixture()

    %{match: match, team: team, players: players, users: users}
  end

  describe "rate page" do
    test "redirects to log in if user is not logged", %{conn: conn, match: match, team: team} do
      {:error, {:redirect, %{to: "/"}}} = live(conn, ~p"/matches/#{match.id}/rate/#{team.id}")
    end

    test "displays players and back to match", %{
      conn: conn,
      match: match,
      team: team,
      players: players,
      users: users
    } do
      conn = conn |> log_in_users(users)
      {:ok, view, html} = live(conn, ~p"/matches/#{match.id}/rate/#{team.id}")

      assert Enum.all?(players, fn %{name: p_name} -> html =~ p_name end)
      assert has_element?(view, "#back-to-match-button")
      assert has_element?(view, "#rate-players-button")
    end

    test "assigns ratings to players and redirects when submit", %{
      conn: conn,
      match: match,
      team: team,
      players: players,
      users: users
    } do
      conn = conn |> log_in_users(users)

      {:ok, view, _html} = live(conn, ~p"/matches/#{match.id}/rate/#{team.id}")

      scores =
        players
        |> Enum.map(fn %{id: p_id} ->
          {Integer.to_string(p_id), :rand.uniform(10) |> Integer.to_string()}
        end)
        |> Map.new()

      view |> form("#scores", scores) |> render_submit()

      {path, _} = assert_redirect(view)
      assert path =~ "/ratings/show/"

      match_rating_id = String.split(path, "/") |> Enum.at(-1) |> String.to_integer()
      response_body = get(conn, "/ratings/show/#{match_rating_id}") |> response(200)
      assert Enum.all?(players, fn %{name: p_name} -> response_body =~ p_name end)

      # A bit dirty since we are accessing Repo stuff in a liveview test,
      # check that players ratings are the same as the ones sent
      %{match: m, users: u, player_ratings: pr, team: t} =
        match_rating_id |> Ratings.get_players_ratings()

      assert m.id == match.id
      assert u.id == users.id
      assert t.id == team.id

      assert Enum.all?(pr, fn %{player_id: p_id, score: s} ->
               Map.get(scores, Integer.to_string(p_id)) == Integer.to_string(s)
             end)

      # Attempting to rate again
      assert {:error, {:redirect, %{to: ^path}}} =
               live(conn, ~p"/matches/#{match.id}/rate/#{team.id}")
    end

    test "expired match does not allow to rate players", %{
      conn: conn,
      match: match,
      team: team,
      players: players,
      users: users
    } do
      {:ok, match} =
        match
        |> Ecto.Changeset.change(status: :expired)
        |> Footballratings.Repo.update()

      conn = log_in_users(conn, users)
      {:ok, view, html} = live(conn, ~p"/matches/#{match.id}/rate/#{team.id}")

      assert view |> has_element?("#back-to-match-button")
      assert html =~ "This match is no longer available for rating"

      refute view |> has_element?("#rate-players-button")
      refute view |> has_element?("#scores")
      refute Enum.any?(players, fn %{name: p_name} -> html =~ p_name end)
    end
  end
end
