defmodule FootballratingsWeb.TeamLive.Index do
  use FootballratingsWeb, :live_view

  alias Footballratings.FootballInfo

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <div class="text-l">Input at least 3 characters</div>
      <.simple_form for={@form} id="search-team" phx-change="validate" phx-throttle="300">
        <.input
          value={@form["team_name"]}
          name="team_name"
          type="text"
          label="Team Name"
          required
          class="input input-bordered w-full max-w-xs"
        />
      </.simple_form>
    </div>
    <%= for team <- @teams do %>
      <div class="text-xl"><%= team.name %></div>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:form, %{"team_name" => ""})
     |> assign(:teams, [])}
  end

  def handle_event("validate", %{"team_name" => team_name}, socket) do
    if String.length(team_name) < 3 do
      {:noreply, assign(socket, :teams, [])}
    else
      {:noreply, assign(socket, :teams, FootballInfo.search_teams(team_name))}
    end
  end
end
