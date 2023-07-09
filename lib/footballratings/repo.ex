defmodule Footballratings.Repo do
  use Ecto.Repo,
    otp_app: :footballratings,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 4

  def insert_timestamp_placeholders(structs) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    placeholders = %{timestamp: timestamp}

    new_structs =
      Enum.map(
        structs,
        &Map.merge(&1, %{
          inserted_at: {:placeholder, :timestamp},
          updated_at: {:placeholder, :timestamp}
        })
      )

    {new_structs, placeholders}
  end
end
