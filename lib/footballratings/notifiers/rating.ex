defmodule Footballratings.Notifiers.Rating do
  @moduledoc """
  Handles broadcasting of a new rating for a given Match/Team.
  """
  alias Footballratings.Ratings.MatchRatings
  alias Phoenix.PubSub

  def broadcast_new_rating(%MatchRatings{team_id: tid, match_id: mid}) do
    payload = %{"type" => "new_rating", "match_id" => mid, "team_id" => tid}

    PubSub.broadcast(Footballratings.PubSub, "team:#{tid}", payload)
    PubSub.broadcast(Footballratings.PubSub, "match:#{mid}", payload)
  end
end
