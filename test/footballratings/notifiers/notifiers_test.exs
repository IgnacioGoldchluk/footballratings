defmodule Footballratings.Notifiers.NotifiersTest do
  use FootballratingsWeb.ConnCase
  alias Footballratings.RatingsFixtures
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

  describe "rating notifier" do
    test "broadcast_new_rating/1 broadcasts match topic" do
      %{team_id: tid, match_id: mid} = match_rating = RatingsFixtures.create_match_ratings()

      expected_payload = %{"type" => "new_rating", "match_id" => mid, "team_id" => tid}

      @endpoint.subscribe("match:#{mid}")
      Notifiers.Rating.broadcast_new_rating(match_rating)
      assert_received(^expected_payload)
    end

    test "broadcast_new_rating/1 broadcasts team topic" do
      %{team_id: tid, match_id: mid} = match_rating = RatingsFixtures.create_match_ratings()

      expected_payload = %{"type" => "new_rating", "match_id" => mid, "team_id" => tid}

      @endpoint.subscribe("team:#{tid}")
      Notifiers.Rating.broadcast_new_rating(match_rating)
      assert_received(^expected_payload)
    end
  end
end
