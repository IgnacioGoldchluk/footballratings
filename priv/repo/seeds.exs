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
  external_id: "1b58f321-8e46-4690-a7e9-eb63ec908bbf",
  frequency: 1,
  frequency_type: :months,
  amount: 1500,
  currency: :USD,
  status: :active
})
