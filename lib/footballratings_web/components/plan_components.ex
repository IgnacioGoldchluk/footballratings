defmodule FootballratingsWeb.PlanComponents do
  use FootballratingsWeb, :html
  use Phoenix.Component

  attr(:currency, :atom, required: true)
  attr(:amount, :integer, required: true)
  attr(:frequency, :integer, required: true)
  attr(:frequency_type, :atom, required: true)

  def plan_billing(%{frequency: 1, frequency_type: :months} = assigns) do
    ~H"""
    <%= @amount %> <%= @currency %>/month
    """
  end
end
