defmodule Footballratings.RatingsFixtures do
  # Alias instead of import because I don't want to accidentally fill the local namespace.
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
end
