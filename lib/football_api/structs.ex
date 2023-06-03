defmodule FootballApi.Structs do
  alias FootballApi.Models

  def match_struct() do
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
end
