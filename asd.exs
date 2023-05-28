FootballRatings.FootballAPI.start()

# base_url = "https://v3.football.api-sports.io/"

response = FootballRatings.FootballAPI.get!("/status")
IO.inspect(response)

# response =
#   HTTPoison.get!("https://v3.football.api-sports.io/teams?league=128&season=2023", headers)

# IO.inspect(response)
