defmodule Footballratings.AsciiString do
  @moduledoc """
  Converts strings to ASCII types
  """
  use Ecto.Type

  def type(), do: :string

  def cast(str) when is_binary(str),
    do:
      {:ok, :iconv.convert("utf-8", "ascii//translit", str) |> String.replace(~r/[^\w\s.]/u, "")}

  def cast(_), do: :error

  def dump(val) when is_binary(val), do: {:ok, val}
  def dump(_), do: :error

  def load(val) when is_binary(val), do: {:ok, val}
  def load(_), do: :error
end
