defmodule FootballratingsWeb.PlayerRatingsTimeseries do
  alias Contex.{Dataset, Plot, ContinuousLinearScale, Scale, TimeScale}

  def make_line_plot_dataset(data) do
    data
    |> Enum.map(&Map.update!(&1, :timestamp, fn timestamp -> DateTime.from_unix!(timestamp) end))
    |> Dataset.new()
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
    data
    |> make_line_plot_dataset()
    |> Plot.new(Contex.PointPlot, 600, 300,
      mapping: %{x_col: :timestamp, y_cols: [:average], fill_col: :team},
      custom_y_scale: y_scale(),
      custom_x_formatter: &format_date/1,
      axis_label_rotation: 45,
      y_label: y_label(),
      x_label: x_label()
    )
    |> Plot.plot_options(%{legend_settings: :legend_right})
    |> Plot.to_svg()
  end
end
