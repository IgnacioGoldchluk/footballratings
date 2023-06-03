defmodule FootballApi.Models.Squads do
  defmodule Response do
    defstruct [:response]
  end

  defmodule Players do
    defstruct [:players]
  end

  defmodule Player do
    defstruct [:id, :name, :age]
  end
end

defmodule FootballApi.Models.Squads.Struct do
  alias FootballApi.Models.Squads

  def squad() do
    %Squads.Response{
      response: [%Squads.Players{players: [%Squads.Player{}]}]
    }
  end
end
