Mox.defmock(FootballApiClientMock, for: FootballApi.FootballApiClientBehaviour)
Application.put_env(:footballratings, :api_client, FootballApiClientMock)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Footballratings.Repo, :manual)
