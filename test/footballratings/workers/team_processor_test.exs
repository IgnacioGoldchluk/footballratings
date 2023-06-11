defmodule Footballratings.Workers.TeamProcessorTest do
  use Footballratings.DataCase
  use Oban.Testing, repo: Repo

  import Mox
  import Footballratings.InternalDataFixtures

  describe "team processor test" do
    test "fetches a team and inserts players" do
      lanus_id = 446

      expect(FootballApiClientMock, :get, fn
        "/players/squads", %{"team" => ^lanus_id} ->
          Footballratings.ApiResponsesFixtures.lanus_squad_response()
      end)

      create_team(name: "Club Atletico Lanus", id: lanus_id)

      assert :ok == perform_job(Footballratings.Workers.TeamProcessor, %{"team_id" => lanus_id})

      players =
        Footballratings.FootballInfo.Player
        |> Ecto.Query.where([p], p.team_id == ^lanus_id)
        |> Repo.aggregate(:count)

      assert players == 36
    end
  end
end
