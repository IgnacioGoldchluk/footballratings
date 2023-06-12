defmodule Footballratings.ApiResponsesFixtures do
  @path "test/support/fixtures/responses"

  def read_file(filename), do: File.read!("#{@path}/#{filename}")

  def match_response() do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body: read_file("matches.txt"),
       headers: [
         {"X-Api-Errors", "0"}
       ],
       request_url:
         "https://v3.football.api-sports.io/fixtures?from=2023-06-10&league=128&season=2023&to=2023-06-10",
       request: %HTTPoison.Request{
         method: :get,
         url:
           "https://v3.football.api-sports.io/fixtures?from=2023-06-10&league=128&season=2023&to=2023-06-10",
         headers: ["x-rapidapi-key": "secret_key"],
         body: "",
         params: %{
           "from" => "2023-06-10",
           "league" => 128,
           "season" => 2023,
           "to" => "2023-06-10"
         },
         options: [
           params: %{
             "from" => "2023-06-10",
             "league" => 128,
             "season" => 2023,
             "to" => "2023-06-10"
           }
         ]
       }
     }}
  end

  def lineups_lanus_boca_response() do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body: read_file("lineups.txt"),
       headers: [
         {"X-Api-Errors", "0"}
       ],
       request_url: "https://v3.football.api-sports.io/fixtures/lineups?fixture=971587",
       request: %HTTPoison.Request{
         method: :get,
         url: "https://v3.football.api-sports.io/fixtures/lineups?fixture=971587",
         headers: ["x-rapidapi-key": "secret_key"],
         body: "",
         params: %{"fixture" => 971_587},
         options: [params: %{"fixture" => 971_587}]
       }
     }}
  end

  def players_statistics_response() do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body: read_file("players_statistics.txt"),
       headers: [
         {"X-Api-Errors", "0"}
       ],
       request_url: "https://v3.football.api-sports.io/fixtures/players?fixture=971587",
       request: %HTTPoison.Request{
         method: :get,
         url: "https://v3.football.api-sports.io/fixtures/players?fixture=971587",
         headers: ["x-rapidapi-key": "secret_key"],
         body: "",
         params: %{"fixture" => 971_587},
         options: [params: %{"fixture" => 971_587}]
       }
     }}
  end

  def lanus_squad_response() do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body: read_file("lanus_squad.txt"),
       headers: [
         {"X-Api-Errors", "0"}
       ],
       request_url: "https://v3.football.api-sports.io/players/squads?team=446",
       request: %HTTPoison.Request{
         method: :get,
         url: "https://v3.football.api-sports.io/players/squads?team=446",
         headers: ["x-rapidapi-key": "secret_key"],
         body: "",
         params: %{"team" => 446},
         options: [params: %{"team" => 446}]
       }
     }}
  end

  def boca_squad_response() do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body: read_file("boca_squad.txt"),
       headers: [
         {"X-Api-Errors", "0"}
       ],
       request_url: "https://v3.football.api-sports.io/players/squads?team=451",
       request: %HTTPoison.Request{
         method: :get,
         url: "https://v3.football.api-sports.io/players/squads?team=451",
         headers: ["x-rapidapi-key": "secret_key"],
         body: "",
         params: %{"team" => 451},
         options: [params: %{"team" => 451}]
       }
     }}
  end
end