defmodule FootballApi.Models.Lineups do
  @moduledoc """
  Lineup struct
  """
  defmodule Response do
    defstruct [:response]
  end

  defmodule Lineup do
    defstruct [:coach, :startXI, :substitutes, :team]
  end

  defmodule CoachLineup do
    defstruct [:id]
  end

  defmodule PlayerLineup do
    defstruct [:player]
  end

  defmodule PlayerIdLineup do
    defstruct [:id]
  end

  defmodule Team do
    defstruct [:id]
  end
end

defmodule FootballApi.Models.Lineups.Struct do
  alias FootballApi.Models.Lineups

  def lineups() do
    %Lineups.Response{
      response: [
        %Lineups.Lineup{
          coach: %Lineups.CoachLineup{},
          startXI: [%Lineups.PlayerLineup{player: %Lineups.PlayerIdLineup{}}],
          substitutes: [%Lineups.PlayerLineup{player: %Lineups.PlayerIdLineup{}}],
          team: %Lineups.Team{}
        }
      ]
    }
  end
end
