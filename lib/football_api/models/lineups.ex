defmodule FootballApi.Models.Lineups do
  @moduledoc """
  Lineup struct
  """
  defmodule Response do
    @moduledoc """
    Response
    """
    defstruct [:response]
  end

  defmodule Lineup do
    @moduledoc """
    Lineup
    """
    defstruct [:coach, :startXI, :substitutes, :team]
  end

  defmodule CoachLineup do
    @moduledoc """
    CoachLineup
    """
    defstruct [:id, :name]
  end

  defmodule PlayerLineup do
    @moduledoc """
    PlayerLineup
    """
    defstruct [:player]
  end

  defmodule PlayerIdLineup do
    @moduledoc """
    PlayerIdLineup
    """
    defstruct [:id]
  end

  defmodule Team do
    @moduledoc """
    Team
    """
    defstruct [:id]
  end
end

defmodule FootballApi.Models.Lineups.Struct do
  @moduledoc """
  Lineups definitions.
  """
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
