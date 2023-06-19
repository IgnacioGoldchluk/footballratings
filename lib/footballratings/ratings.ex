defmodule Footballratings.Ratings do
  alias Footballratings.Repo
  alias Footballratings.Ratings.{PlayerRatings, MatchRatings}
  alias Footballratings.FootballInfo.{Player, Team}
  alias Footballratings.Accounts.{Users}

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

  def create_player_ratings!(attrs) do
    %PlayerRatings{}
    |> PlayerRatings.changeset(attrs)
    |> Repo.insert!()
  end

  def get_players_ratings(match_rating_id) do
    from(pr in PlayerRatings,
      join: p in Player,
      on: pr.player_id == p.id,
      join: mr in MatchRatings,
      on: mr.id == pr.match_rating_id,
      join: t in Team,
      on: mr.team_id == t.id,
      join: u in Users,
      on: mr.user_id == u.id
    )
    |> where([pr, p, mr, t, u], pr.match_rating_id == ^match_rating_id)
    |> select(
      [pr, p, mr, t, u],
      %{
        id: p.id,
        name: p.name,
        score: pr.score,
        team: %{id: t.id, name: t.name},
        user: %{id: u.id, name: u.username}
      }
    )
    |> Repo.all()
    |> format_players_ratings()
  end

  # Empty list case
  defp format_players_ratings([]), do: []

  defp format_players_ratings([%{team: team, user: user} | _rest] = players_ratings) do
    players_without_team_and_user =
      players_ratings
      |> Enum.map(&Map.drop(&1, [:team, :user]))

    %{team: team, user: user, players: players_without_team_and_user}
  end

  def create_match_and_players_ratings(players, scores, team_id, match_id, user_id) do
    Repo.transaction(fn ->
      {:ok, match_ratings} =
        create_match_ratings(%{user_id: user_id, team_id: team_id, match_id: match_id})

      # Must do it with changesets, otherwise the transaction raises instead of rolling back
      players
      |> players_ratings_maps(scores, match_ratings.id)
      |> Enum.map(&create_player_ratings!/1)

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
