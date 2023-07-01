defmodule FootballratingsWeb.LiveStatsPubSub do
  alias Phoenix.PubSub

  def subscribe() do
    PubSub.subscribe(Footballratings.PubSub, "live_stats")
  end

  def broadcast(new_val) do
    PubSub.broadcast(Footballratings.PubSub, "live_stats", new_val)
  end
end
