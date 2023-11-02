defmodule Footballratings.Delays do
  @moduledoc """
  Utility to reduce sleeps/delays when testing
  """

  def scale(delay) do
    case Application.get_env(:footballratings, :delays, true) do
      true -> delay
      false -> 1
    end
  end
end
