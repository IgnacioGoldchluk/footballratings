defmodule FootballratingsWeb.PlayerLive.Search do
  defstruct [:name]

  @types %{
    name: :string
  }

  import Ecto.Changeset

  def changeset(%__MODULE__{} = search_opts, attrs) do
    {search_opts, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
  end
end
