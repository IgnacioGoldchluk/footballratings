defmodule Footballratings.Delays do
  def scale(delay) do
    case Application.get_env(:footballratings, :delay, true) do
      true -> delay
      false -> 1
    end
  end
end
