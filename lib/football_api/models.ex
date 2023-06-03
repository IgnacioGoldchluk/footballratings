defmodule FootballApi.Models do
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
    defstruct [:id]
  end

  defmodule Status do
    defstruct [:short]
  end

  defmodule League do
    defstruct [:id, :season, :round]
  end
end
