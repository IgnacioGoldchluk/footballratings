defmodule Footballratings.LiveStats do
  use GenServer
  @update_interval_milliseconds 60_000

  alias Footballratings.{FootballInfo, Accounts, Ratings}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    # Start empty and send an update
    initial_state = %{users: nil, matches: nil, ratings: nil}
    {:ok, initial_state, {:continue, :update}}
  end

  @impl true
  def handle_continue(:update, _state) do
    Process.send_after(self(), :update, @update_interval_milliseconds)
    {:noreply, get_stats()}
  end

  @impl true
  def handle_info(:update, _state) do
    new_state = get_stats()

    FootballratingsWeb.LiveStatsPubSub.broadcast(new_state)
    Process.send_after(self(), :update, @update_interval_milliseconds)

    {:noreply, new_state}
  end

  @impl true
  def handle_call("live_stats", _from, state) do
    {:reply, state, state}
  end

  defp get_stats() do
    %{
      "users" => Accounts.total_users(),
      "matches" => FootballInfo.total_matches(),
      "ratings" => Ratings.total_match_ratings()
    }
  end
end
