defmodule FootballratingsWeb.MatchRatingsController do
  use FootballratingsWeb, :controller

  alias Footballratings.Ratings

  def show(conn, %{"match_ratings_id" => match_ratings_id}) do
    %{
      match: match,
      users: user,
      player_ratings: player_ratings,
      inserted_at: inserted_at
    } =
      match_ratings_id
      |> String.to_integer()
      |> Ratings.get_players_ratings()

    render(conn, :show,
      match: match,
      user: user,
      player_ratings: player_ratings,
      inserted_at: inserted_at
    )
  end
end
