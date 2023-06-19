defmodule Footballratings.Ratings do
  alias Footballratings.Repo
  alias Footballratings.Ratings.{PlayerRatings, MatchRatings}

  import Ecto.Query

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

  def create_match_and_players_ratings(players_ratings, match_id, team_id, user_id) do
    Repo.transaction(fn ->
      {:ok, match_ratings} =
        create_match_ratings(%{user_id: user_id, team_id: team_id, match_id: match_id})

      players_ratings =
        players_ratings
        |> Enum.flat_map(&scores_to_maps/1)
        |> Enum.map(&insert_match_id_and_team_id(&1, match_id, team_id))
    end)
  end

  defp scores_to_maps(players_scores) do
    players_scores
    |> Enum.map(fn {k, v} -> %{id: k, score: String.to_integer(v)} end)
  end

  defp insert_match_id_and_team_id(players_score, match_id, team_id) do
    players_score |> Map.put(:match_id, match_id) |> Map.put(:team_id, team_id)
  end
end
