defmodule FootballApi.Models.Matches do
  @moduledoc """
  Match struct
  """
  defmodule Response do
    @moduledoc """
    Response
    """
    defstruct [:response]
  end

  defmodule Match do
    @moduledoc """
    Match
    """
    defstruct [:fixture, :score, :teams, :league]
  end

  defmodule Fixture do
    @moduledoc """
    Fixture
    """
    defstruct [:id, :status, :timestamp]
  end

  defmodule Score do
    @moduledoc """
    Score
    """
    defstruct [:extratime, :fulltime, :halftime, :penalty]
  end

  defmodule TemporalScore do
    @moduledoc """
    TemporalScore
    """
    defstruct [:away, :home]
  end

  defmodule Teams do
    @moduledoc """
    Teams
    """
    defstruct [:away, :home]
  end

  defmodule Team do
    @moduledoc """
    Team
    """
    defstruct [:id, :name]
  end

  defmodule Status do
    @moduledoc """
    Status
    """
    defstruct [:short]
  end

  defmodule League do
    @moduledoc """
    League
    """
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
