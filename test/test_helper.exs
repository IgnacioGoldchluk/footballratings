Mox.defmock(FootballApiClientMock, for: FootballApi.FootballApiClientBehaviour)
Mox.defmock(MercadoPagoClientMock, for: Footballratings.MercadoPago.ClientBehaviour)
Application.put_env(:footballratings, :api_client, FootballApiClientMock)
Application.put_env(:footballratings, :mercado_pago_client, MercadoPagoClientMock)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Footballratings.Repo, :manual)
