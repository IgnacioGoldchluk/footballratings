defmodule Footballratings.ApiResponsesFixtures do
  @path "test/footballratings/football_api/responses"

  def read_file(filename), do: File.read("#{@path}/#{filename}")

  def squads_body(), do: read_file("squads.txt")
  def lineups_body(), do: read_file("lineups.txt")
  def matches_body(), do: read_file("matches.txt")
  def players_statistics_body(), do: read_file("players_statistics.txt")
end
