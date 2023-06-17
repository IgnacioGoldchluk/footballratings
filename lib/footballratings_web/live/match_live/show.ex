defmodule FootballratingsWeb.MatchLive.Show do
  use FootballratingsWeb, :live_view
  # use Phoenix.Component
  # use Phoenix.HTML

  alias Footballratings.FootballInfo

  def render(assigns) do
    ~H"""
    <.match match={@match} />
    """
  end

  def mount(%{"id" => match_id}, _session, socket) do
    {:ok,
     assign(
       socket,
       :match,
       FootballInfo.get_match_with_team_and_league(String.to_integer(match_id))
     )}
  end
end
