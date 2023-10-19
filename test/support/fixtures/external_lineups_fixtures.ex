defmodule Footballratings.ExternalLineupsFixtures do
  @moduledoc """
  Fixtures for data coming from the 3rd party API
  """

  @letters 'abcdefghijklmnopqrstuvwxyz'

  def create_coach_lineup(id \\ System.unique_integer([:positive])) do
    %{"id" => id, "name" => Enum.take_random(@letters, 10)}
  end

  def create_playerid_lineup(id), do: %{"id" => id}

  def create_player(id), do: %{"player" => create_playerid_lineup(id)}

  def create_team(id \\ System.unique_integer([:positive])), do: %{"id" => id}

  def create_lineup() do
    %{
      "startXI" => Enum.map(1..20, &create_player/1),
      "substitutes" => Enum.map(1..20, &create_player/1),
      "coach" => create_coach_lineup(),
      "team" => create_team()
    }
  end

  def insert_coach(lineup, coach), do: Map.put(lineup, "coach", coach)
end
