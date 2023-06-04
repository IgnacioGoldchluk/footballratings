defmodule FootballApi.Models.Matches do
  @moduledoc """
  Match struct
  """
  defmodule Response do
    defstruct [:response]
  end

  defmodule Match do
    defstruct [:fixture, :score, :teams, :league]
  end

  defmodule Fixture do
    defstruct [:id, :status, :timestamp]
  end

  defmodule Score do
    defstruct [:extratime, :fulltime, :halftime, :penalty]
  end

  defmodule TemporalScore do
    defstruct [:away, :home]
  end

  defmodule Teams do
    defstruct [:away, :home]
  end

  defmodule Team do
    defstruct [:id, :name]
  end

  defmodule Status do
    defstruct [:short]
  end

  defmodule League do
    defstruct [:id, :season, :round, :name]
  end
end

defmodule FootballApi.Models.Matches.Struct do
  @moduledoc """
  Match definition.
  """
  alias FootballApi.Models.Matches

  def match() do
    %Matches.Response{
      response: [
        %Matches.Match{
          fixture: %Matches.Fixture{status: %Matches.Status{}},
          score: %Matches.Score{
            extratime: %Matches.TemporalScore{},
            fulltime: %Matches.TemporalScore{},
            halftime: %Matches.TemporalScore{},
            penalty: %Matches.TemporalScore{}
          },
          teams: %Matches.Teams{away: %Matches.Team{}, home: %Matches.Team{}},
          league: %Matches.League{}
        }
      ]
    }
  end
end
