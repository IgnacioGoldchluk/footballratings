defmodule Footballratings.Notifiers.Match do
  alias Footballratings.FootballInfo.Match
  alias Phoenix.PubSub

  def broadcast_new_match(%Match{id: match_id, home_team_id: ht_id, away_team_id: at_id}) do
    payload = %{"type" => "new_match", "match_id" => match_id}

    PubSub.broadcast(Footballratings.PubSub, "new_match", payload)
    PubSub.broadcast(Footballratings.PubSub, "team:#{ht_id}", payload)
    PubSub.broadcast(Footballratings.PubSub, "team:#{at_id}", payload)
  end
end
