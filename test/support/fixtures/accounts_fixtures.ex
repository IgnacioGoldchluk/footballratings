defmodule Footballratings.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Footballratings.Accounts` context.
  """

  def unique_users_email, do: "users#{System.unique_integer()}@example.com"
  def valid_users_password, do: "Hello_World123"
  def unique_username, do: "Person_#{System.unique_integer([:positive])}"

  def valid_users_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_users_email(),
      password: valid_users_password(),
      username: unique_username()
    })
  end

  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> valid_users_attributes()
      |> Footballratings.Accounts.register_users()

    users
  end
end
