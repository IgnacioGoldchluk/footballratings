defmodule FootballApi.Models.PlayersStatistics do
  @moduledoc """
  Players statistics structs.
  """
  defmodule Response do
    @moduledoc """
    Response
    """
    defstruct [:response]
  end

  defmodule Team do
    @moduledoc """
    Team
    """
    defstruct [:id]
  end

  defmodule Players do
    @moduledoc """
    Players
    """
    defstruct [:players, :team]
  end

  defmodule Player do
    @moduledoc """
    Player
    """
    defstruct [:player, :statistics]
  end

  defmodule PlayerInfo do
    @moduledoc """
    PlayerInfo
    """
    defstruct [:id]
  end

  defmodule Games do
    @moduledoc """
    Games
    """
    defstruct [:games]
  end

  defmodule GameStatistics do
    @moduledoc """
    GameStatistics
    """
    defstruct [:minutes]
  end
end

defmodule FootballApi.Models.PlayersStatistics.Struct do
  @moduledoc """
  Player Statistics definition.
  """
  alias FootballApi.Models.PlayersStatistics, as: Stats

  def players_statistics() do
    %Stats.Response{
      response: [
        %Stats.Players{
          team: %Stats.Team{},
          players: [
            %Stats.Player{
              player: %Stats.PlayerInfo{},
              statistics: [
                %Stats.Games{
                  games: %Stats.GameStatistics{}
                }
              ]
            }
          ]
        }
      ]
    }
  end
end
