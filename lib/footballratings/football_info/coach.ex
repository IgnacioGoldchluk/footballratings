defmodule Footballratings.FootballInfo.Coach do
  use Ecto.Schema
  import Ecto.Changeset

  alias Footballratings.FootballInfo.Team

  schema "coaches" do
    field :name, :string
    field :firstname, :string
    field :lastname, :string
    field :age, :integer

    timestamps()

    belongs_to :team, Team
  end

  def changeset(coach, attrs) do
    coach
    |> cast(attrs, [:name, :firstname, :lastname, :age, :id, :team_id])
    |> validate_required([:name, :id, :team_id])
    |> unique_constraint(:id)
  end
end
