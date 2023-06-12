defmodule Footballratings.Workers.FixturesFetchTest do
  use Footballratings.DataCase
  use Oban.Testing, repo: Repo

  alias Footballratings.FootballInfo

  import Mox

  describe "fixtures fetch test" do
    test "complete flow" do
      match_id = 971_587
      lanus_id = 446
      boca_id = 451

      stub(FootballApiClientMock, :get, fn
        "/fixtures", %{"league" => 128, "season" => 2023, "from" => from, "to" => to} ->
          assert from == Date.utc_today() |> Date.add(-1)
          assert to == Date.utc_today()
          Footballratings.ApiResponsesFixtures.match_response()

        "/players/squads", %{"team" => ^lanus_id} ->
          Footballratings.ApiResponsesFixtures.lanus_squad_response()

        "/players/squads", %{"team" => ^boca_id} ->
          Footballratings.ApiResponsesFixtures.boca_squad_response()

        "/fixtures/players", %{"fixture" => ^match_id} ->
          Footballratings.ApiResponsesFixtures.players_statistics_response()

        "/fixtures/lineups", %{"fixture" => ^match_id} ->
          Footballratings.ApiResponsesFixtures.lineups_lanus_boca_response()
      end)

      :ok =
        perform_job(Footballratings.Workers.FixturesFetch, %{"league" => 128, "season" => 2023})

      # League was inserted correctly
      [league] = Repo.all(FootballInfo.League)
      assert league.id == 128

      match = Repo.get(FootballInfo.Match, match_id)
      assert match.status == :ready
      assert match.home_team_id == boca_id
      assert match.away_team_id == lanus_id

      lanus_players =
        FootballInfo.Player
        |> Ecto.Query.where([p], p.team_id == ^lanus_id)
        |> Repo.aggregate(:count)

      assert lanus_players == 36

      boca_players =
        FootballInfo.Player
        |> Ecto.Query.where([p], p.team_id == ^boca_id)
        |> Repo.aggregate(:count)

      assert boca_players == 46

      players_who_played =
        FootballInfo.PlayerMatch
        |> Ecto.Query.where([p_m], p_m.match_id == ^match_id)
        |> Repo.aggregate(:count)

      assert players_who_played == 29

      players_who_played_for_lanus =
        FootballInfo.PlayerMatch
        |> Ecto.Query.where([p_m], p_m.match_id == ^match_id and p_m.team_id == ^lanus_id)
        |> Repo.aggregate(:count)

      assert players_who_played_for_lanus == 15

      assert length(Repo.all(FootballInfo.Coach)) == 2
    end
  end
end
