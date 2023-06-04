defmodule FootballApi.Models.Squads do
  @moduledoc """
  Squads structs.
  """

  defmodule Response do
    @moduledoc """
    Response
    """
    defstruct [:response]
  end

  defmodule Players do
    @moduledoc """
    Players
    """
    defstruct [:players]
  end

  defmodule Player do
    @moduledoc """
    Player
    """
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
