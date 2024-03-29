defmodule Footballratings.RatingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Footballratings.Ratings` context.
  """

  alias Footballratings.InternalDataFixtures
  alias Footballratings.AccountsFixtures

  alias Footballratings.Ratings

  def create_match_ratings(attrs \\ %{}) do
    match = InternalDataFixtures.create_match()
    user = AccountsFixtures.users_fixture()

    {:ok, match_ratings} =
      Enum.into(attrs, %{
        match_id: match.id,
        team_id: match.home_team_id,
        users_id: user.id
      })
      |> Ratings.create_match_ratings()

    match_ratings
  end

  def random_scores(players) do
    players
    |> Enum.map(fn %{id: player_id} ->
      {Integer.to_string(player_id), Integer.to_string(Enum.random(1..10))}
    end)
    |> Map.new()
  end

  def create_player_rating(attrs \\ %{}) do
    {:ok, rating} = Ratings.create_player_ratings(attrs)
    rating
  end
end
