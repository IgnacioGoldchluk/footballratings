# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Footballratings.Repo.insert!(%Footballratings.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Footballratings.Repo.insert!(%Footballratings.Billing.Plan{
  external_id: Ecto.UUID.generate(),
  frequency: 1,
  frequency_type: :months,
  amount: 399,
  currency: :ARS,
  status: :active
})
