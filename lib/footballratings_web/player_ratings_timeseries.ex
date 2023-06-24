defmodule FootballratingsWeb.PlayerRatingsTimeseries do
  alias Contex.{Dataset, LinePlot, Plot, ContinuousLinearScale, Scale, TimeScale}

  def make_line_plot_dataset(data) do
    data
    |> Enum.map(fn %{average: average, timestamp: timestamp, team: team} ->
      {timestamp |> DateTime.from_unix!(), average, team}
    end)
    |> Dataset.new(["x", "y", "category"])
  end

  def y_label(), do: "Average ratings"
  def x_label(), do: "Date"

  def y_scale() do
    ContinuousLinearScale.new()
    |> ContinuousLinearScale.domain(0, 10)
    |> ContinuousLinearScale.interval_count(5)
    |> Scale.set_range(0, 10)
  end

  def x_scale() do
    TimeScale.new()
  end

  def format_date(datetime), do: datetime |> DateTime.to_date() |> to_string()

  def plot(data) do
    dataset = make_line_plot_dataset(data)

    IO.inspect(dataset)

    Plot.new(dataset, Contex.LinePlot, 800, 300,
      custom_y_scale: y_scale(),
      custom_x_formatter: &format_date/1,
      axis_label_rotation: 45,
      y_label: y_label(),
      x_label: x_label()
    )
    |> Plot.to_svg()
  end
end
