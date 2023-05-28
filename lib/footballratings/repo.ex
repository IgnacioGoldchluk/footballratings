defmodule Footballratings.Repo do
  use Ecto.Repo,
    otp_app: :footballratings,
    adapter: Ecto.Adapters.Postgres
end
