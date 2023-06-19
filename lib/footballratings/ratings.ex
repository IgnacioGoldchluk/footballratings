defmodule Footballratings.Ratings do
  alias Footballratings.Repo
  alias Footballratings.Ratings.{PlayerRatings, MatchRatings}

  def create_match_ratings(attrs) do
    %MatchRatings{}
    |> MatchRatings.changeset(attrs)
    |> Repo.insert()
  end

  def create_player_ratings(attrs) do
    %PlayerRatings{}
    |> PlayerRatings.changeset(attrs)
    |> Repo.insert()
  end

  def create_match_and_players_ratings(players, scores, team_id, match_id, user_id) do
    Repo.transaction(fn ->
      {:ok, match_ratings} =
        create_match_ratings(%{user_id: user_id, team_id: team_id, match_id: match_id})

      # Must do it with changesets, otherwise the transaction raises instead of rolling back
      players
      |> players_ratings_maps(scores, match_ratings.id)
      |> Enum.each(&create_player_ratings/1)

      match_ratings.id
    end)
  end

  defp players_ratings_maps(players, scores, match_rating_id) do
    players
    |> Enum.map(fn player ->
      player
      |> Map.delete(:name)
      |> Map.put(:player_id, Map.get(player, :id))
      |> Map.put(:match_rating_id, match_rating_id)
      |> Map.put(
        :score,
        Map.get(scores, player[:id] |> Integer.to_string()) |> String.to_integer()
      )
    end)
  end
end
