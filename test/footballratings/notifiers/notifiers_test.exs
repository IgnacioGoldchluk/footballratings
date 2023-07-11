defmodule Footballratings.Notifiers.NotifiersTest do
  use FootballratingsWeb.ConnCase
  alias Footballratings.InternalDataFixtures

  alias Footballratings.Notifiers

  @endpoint FootballratingsWeb.Endpoint

  describe "match notifier" do
    test "broadcast_new_match/1 broadcasts match topic" do
      %{id: mid} = match = InternalDataFixtures.create_match()

      expected_payload = %{"type" => "new_match", "match_id" => mid}
      @endpoint.subscribe("new_match")

      Notifiers.Match.broadcast_new_match(match)
      assert_received(^expected_payload)
    end

    test "broadcast_new_match/1 broadcasts home team topic" do
      %{id: mid, home_team_id: htid} = match = InternalDataFixtures.create_match()

      expected_payload = %{"type" => "new_match", "match_id" => mid}

      @endpoint.subscribe("team:#{htid}")

      Notifiers.Match.broadcast_new_match(match)
      assert_received(^expected_payload)
    end

    test "broadcast_new_match/1 broadcasts away team topic" do
      %{id: mid, away_team_id: atid} = match = InternalDataFixtures.create_match()

      expected_payload = %{"type" => "new_match", "match_id" => mid}

      @endpoint.subscribe("team:#{atid}")

      Notifiers.Match.broadcast_new_match(match)
      assert_received(^expected_payload)
    end
  end
end
