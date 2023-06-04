defmodule FootballApi.Models.PlayersStatistics do
  defmodule Response do
    defstruct [:response]
  end

  defmodule Team do
    defstruct [:id]
  end

  defmodule Players do
    defstruct [:players, :team]
  end

  defmodule Player do
    defstruct [:player, :statistics]
  end

  defmodule PlayerInfo do
    defstruct [:id]
  end

  defmodule Games do
    defstruct [:games]
  end

  defmodule GameStatistics do
    defstruct [:minutes]
  end
end

defmodule FootballApi.Models.PlayersStatistics.Struct do
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
