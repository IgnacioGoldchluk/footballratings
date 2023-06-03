defmodule FootballApi.Structs do
  alias FootballApi.Models

  def match() do
    %Models.Response{
      response: [
        %Models.Match{
          fixture: %Models.Fixture{status: %Models.Status{}},
          score: %Models.Score{
            extratime: %Models.TemporalScore{},
            fulltime: %Models.TemporalScore{},
            halftime: %Models.TemporalScore{},
            penalty: %Models.TemporalScore{}
          },
          teams: %Models.Teams{away: %Models.Team{}, home: %Models.Team{}},
          league: %Models.League{}
        }
      ]
    }
  end

  def lineups() do
    %Models.Response{
      response: [
        %Models.Lineup{
          coach: %Models.CoachLineup{},
          startXI: [%Models.PlayerLineup{player: %Models.PlayerIdLineup{}}],
          substitutes: [%Models.PlayerLineup{player: %Models.PlayerIdLineup{}}],
          team: %Models.Team{}
        }
      ]
    }
  end
end
