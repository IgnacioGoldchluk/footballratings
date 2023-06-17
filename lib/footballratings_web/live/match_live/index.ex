defmodule FootballratingsWeb.MatchLive.Index do
  use FootballratingsWeb, :live_view
  alias Footballratings.FootballInfo

  @max_matches 10

  @impl true
  def mount(_params, _session, socket) do
    matches = FootballInfo.matches_available_for_rating()

    {:ok,
     stream(socket, :matches, matches,
       dom_id: &"matches-#{&1.match.id}",
       at: 0,
       limit: @max_matches
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="matches" phx-update="stream">
      <div :for={{dom_id, available_match} <- @streams.matches} id={dom_id}>
        <div class="py-2">
          <.match match={available_match} />
        </div>
      </div>
    </div>
    """
  end
end
