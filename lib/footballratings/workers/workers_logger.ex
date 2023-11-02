defmodule Footballratings.Workers.WorkersLogger do
  @moduledoc """
  Callbacks to log Oban events.
  """

  require Logger

  def handle_event([:oban, :job, :start], measure, meta, _) do
    Logger.warning("[Oban] :started #{meta.worker} at #{measure.system_time}")
  end

  def handle_event([:oban, :job, event], measure, meta, _) do
    Logger.warning("[Oban] #{event} #{meta.worker} ran in #{measure.duration}")
  end
end
