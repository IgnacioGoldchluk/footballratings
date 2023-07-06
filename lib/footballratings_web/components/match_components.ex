defmodule FootballratingsWeb.MatchComponents do
  use FootballratingsWeb, :html
  use Phoenix.Component

  def matches_table(%{matches: %{inserts: []}} = assigns) do
    ~H"""

    """
  end

  def matches_table(assigns) do
    ~H"""
    <table class="table table-zebra">
      <thead>
        <tr>
          <th>League</th>
          <th>Round</th>
          <th>Home Team</th>
          <th>Result</th>
          <th>Away Team</th>
          <th></th>
        </tr>
      </thead>
      <tbody id="matches" phx-update="stream">
        <tr :for={{match_id, match} <- @matches} id={match_id} %>
          <.match_row match={match} />
        </tr>
      </tbody>
    </table>
    <div id="infinite-scroll-marker" phx-hook="InfiniteScroll"></div>
    """
  end

  def match_row(assigns) do
    ~H"""
    <td><%= @match.league.name %></td>
    <td><%= @match.round %></td>
    <td>
      <.team_row
        team_name={@match.home_team.name}
        team_id={@match.home_team.id}
        match_id={@match.id}
        rateable={@match.status == :ready}
      />
    </td>
    <td>
      <.result_row
        goals_home={@match.goals_home}
        goals_away={@match.goals_away}
        penalties_home={@match.penalties_home}
        ,
        penalties_away={@match.penalties_away}
      />
    </td>
    <td>
      <.team_row
        team_name={@match.away_team.name}
        team_id={@match.away_team.id}
        match_id={@match.id}
        rateable={@match.status == :ready}
      />
    </td>
    <td>
      <.link navigate={~p"/ratings/match/#{@match.id}"} class="hover:text-primary">Stats</.link>
    </td>
    """
  end

  def team_row(%{rateable: false} = assigns) do
    ~H"""
    <%= @team_name %>
    """
  end

  def team_row(%{rateable: true} = assigns) do
    ~H"""
    <.link navigate={~p"/matches/#{@match_id}/rate/#{@team_id}"} class="hover:text-primary">
      <%= @team_name %>
    </.link>
    """
  end

  def result_row(%{penalties_home: nil} = assigns) do
    ~H"""
    <div class="flex">
      <div><%= @goals_home %></div>
      <div>-</div>
      <div><%= @goals_away %></div>
    </div>
    """
  end

  def result_row(assigns) do
    ~H"""
    <div class="flex">
      <div><%= @goals_home %></div>
      <div>(<%= @penalties_home %>)</div>
      <div>-</div>
      <div>(<%= @penalties_away %>)</div>
      <div><%= @goals_away %></div>
    </div>
    """
  end

  def match_result(assigns) do
    ~H"""
    <.match match={@match} rate={false} />
    """
  end

  def match(assigns) do
    ~H"""
    <h2 class="font-semibold"><%= @match.league.name %> - <%= @match.round %></h2>
    <div class="join-vertical">
      <.team
        team={@match.home_team}
        goals={@match.goals_home}
        penalties={@match.penalties_home}
        match_id={@match.id}
        rate={@rate}
      />
      <.team
        team={@match.away_team}
        goals={@match.goals_away}
        penalties={@match.penalties_away}
        match_id={@match.id}
        rate={@rate}
      />
    </div>
    """
  end

  defp team(assigns) do
    ~H"""
    <div class="grid w-min bg-white border-solid border-2 border-primary join-item rounded-lg">
      <div class="flex justify-between flex-auto">
        <img src="/images/team.jpg" width="50" />
        <p class="w-48 font-semibold pl-4 py-2"><%= @team.name %></p>
        <.result goals={@goals} penalties={@penalties} />
        <%= if @rate do %>
          <.link navigate={"/matches/#{@match_id}/rate/#{@team.id}"} class="py-1 px-1">
            <button class="btn btn-primary">Rate players</button>
          </.link>
        <% end %>
      </div>
    </div>
    """
  end

  defp result(assigns) do
    ~H"""
    <%= if @penalties != nil do %>
      <p class="font-semibold w-16 py-2"><%= @goals %> (<%= @penalties %>)</p>
    <% else %>
      <p class="font-semibold w-16 py-2"><%= @goals %></p>
    <% end %>
    """
  end
end
