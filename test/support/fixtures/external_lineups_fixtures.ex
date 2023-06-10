defmodule Footballratings.ExternalLineupsFixtures do
  @moduledoc """
  Fixtures for data coming from the 3rd party API
  """

  alias FootballApi.Models.Lineups.{
    CoachLineup,
    Lineup,
    PlayerLineup,
    PlayerIdLineup,
    Team
  }

  @letters 'abcdefghijklmnopqrstuvwxyz'

  def create_coach_lineup(id \\ System.unique_integer([:positive])) do
    %CoachLineup{id: id, name: Enum.take_random(@letters, 10)}
  end

  def create_playerid_lineup(id) do
    %PlayerIdLineup{id: id}
  end

  def create_player(id) do
    %PlayerLineup{player: create_playerid_lineup(id)}
  end

  def create_team(id \\ System.unique_integer([:positive])) do
    %Team{id: id}
  end

  def create_lineup() do
    %Lineup{
      startXI: Enum.map(1..20, &create_player/1),
      substitutes: Enum.map(1..20, &create_player/1),
      coach: create_coach_lineup(),
      team: create_team()
    }
  end

  def insert_coach(%Lineup{} = lineup, %CoachLineup{} = coach) do
    %Lineup{lineup | coach: coach}
  end
end
