defmodule Footballratings.FootballApi.ResponseValidationTest do
  use Footballratings.DataCase

  import Footballratings.ApiResponsesFixtures

  alias FootballApi.Models

  describe "body validation" do
    test "matches" do
      {:ok, match} = match_response()

      assert {:ok, _response_body} =
               FootballApi.ResponseValidation.validate_response(
                 match,
                 Models.Matches.Struct.match()
               )
    end

    test "lineups" do
      {:ok, lineups} = lineups_lanus_boca_response()

      assert {:ok, _response_body} =
               FootballApi.ResponseValidation.validate_response(
                 lineups,
                 Models.Lineups.Struct.lineups()
               )
    end

    test "squads" do
      {:ok, lanus_squad} = lanus_squad_response()
      {:ok, boca_squad} = boca_squad_response()

      assert {:ok, _} =
               FootballApi.ResponseValidation.validate_response(
                 lanus_squad,
                 Models.Squads.Struct.squad()
               )

      assert {:ok, _} =
               FootballApi.ResponseValidation.validate_response(
                 boca_squad,
                 Models.Squads.Struct.squad()
               )
    end

    test "players_statistics" do
      {:ok, players_statistics} = players_statistics_response()

      assert {:ok, _} =
               FootballApi.ResponseValidation.validate_response(
                 players_statistics,
                 Models.PlayersStatistics.Struct.players_statistics()
               )
    end
  end

  describe "extra validation" do
    test "API Errors different from 0 throws an error" do
      {:ok, response} = players_statistics_response()

      response = %HTTPoison.Response{
        response
        | headers: [{"a header", "123"}, {"X-Api-Errors", "2"}]
      }

      assert {:error, string} = FootballApi.ResponseValidation.validate_response(response, %{})
      assert String.contains?(string, "X-Api-Errors")
    end

    test "status code different from 200 throws an error" do
      {:ok, response} = players_statistics_response()
      response = %HTTPoison.Response{response | status_code: 500}

      assert {:error, string} = FootballApi.ResponseValidation.validate_response(response, %{})
      assert String.contains?(string, "response status=500")
    end
  end

  describe "to_many_requests_validation" do
    test "returns error when too many requests are found" do
      {:ok, response} = too_many_requests_response()

      assert {:error, string} = FootballApi.ResponseValidation.validate_response(response, %{})

      assert String.contains?(string, "Too many requests")
    end

    test "returns ok when no errors" do
      {:ok, response} = players_statistics_response()

      assert {:ok, _response} = FootballApi.ResponseValidation.validate_response(response, %{})
    end
  end
end
