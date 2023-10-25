defmodule Footballratings.Repo do
  use Ecto.Repo,
    otp_app: :footballratings,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 4

  def upsert(changeset) do
    changeset
    |> insert(on_conflict: :replace_all, conflict_target: :id)
  end
end
