defmodule Footballratings.LiveStats do
  @moduledoc """
  Periodically fetches basic stats and broadcasts the results.
  """

  use GenServer
  @update_interval_milliseconds 60_000

  alias Footballratings.{FootballInfo, Accounts, Ratings}
  alias Phoenix.PubSub

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
  def handle_info(:update, state) do
    Process.send_after(self(), :update, @update_interval_milliseconds)
    update_state_and_broadcast(state)
  end

  @impl true
  def handle_call("live_stats", _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast(:update_stats, state), do: update_state_and_broadcast(state)

  defp get_stats() do
    %{
      "users" => Accounts.total_users(),
      "matches" => FootballInfo.total_matches(),
      "ratings" => Ratings.total_match_ratings()
    }
  end

  defp update_state_and_broadcast(state) do
    new_state = get_stats()

    if new_state != state do
      PubSub.broadcast(Footballratings.PubSub, "live_stats", new_state)
    end

    {:noreply, new_state}
  end
end
