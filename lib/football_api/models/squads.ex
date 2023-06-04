defmodule FootballApi.Models.Squads do
  @moduledoc """
  Squads structs.
  """

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
  @moduledoc """
  Squad struct.
  """
  alias FootballApi.Models.Squads

  def squad() do
    %Squads.Response{
      response: [%Squads.Players{players: [%Squads.Player{}]}]
    }
  end
end
