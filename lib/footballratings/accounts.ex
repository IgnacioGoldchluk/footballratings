defmodule Footballratings.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Footballratings.Repo

  alias Footballratings.Accounts.{Users, UsersToken}

  ## Database getters

  @doc """
  Gets a users by email.

  ## Examples

      iex> get_users_by_email("foo@example.com")
      %Users{}

      iex> get_users_by_email("unknown@example.com")
      nil

  """
  def get_users_by_email(email) when is_binary(email) do
    Repo.get_by(Users, email: email)
  end

  def get_users_by_username(username) when is_binary(username) do
    Repo.get_by(Users, username: username)
  end

  @doc """
  Gets a single users.

  Raises `Ecto.NoResultsError` if the Users does not exist.

  ## Examples

      iex> get_users!(123)
      %Users{}

      iex> get_users!(456)
      ** (Ecto.NoResultsError)

  """
  def get_users!(id), do: Repo.get!(Users, id)

  ## Users registration

  @doc """
  Registers a users.

  ## Examples

      iex> register_users(%{field: value})
      {:ok, %Users{}}

      iex> register_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_users(attrs) do
    %Users{}
    |> Users.registration_changeset(attrs)
    |> Repo.insert()
  end

  ## Settings
  def change_users_username(users, attrs \\ %{}) do
    Users.username_changeset(users, attrs, validate_username: false)
  end

  def update_users_username(users, username) do
    Repo.transaction(users_username_multi(users, username))
  end

  defp users_username_multi(users, username) do
    changeset = users |> Users.username_changeset(%{username: username})

    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, changeset)
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_users_session_token(users) do
    {token, users_token} = UsersToken.build_session_token(users)
    Repo.insert!(users_token)
    token
  end

  @doc """
  Gets the users with the given signed token.
  """
  def get_users_by_session_token(token) do
    {:ok, query} = UsersToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_users_session_token(token) do
    Repo.delete_all(UsersToken.token_and_context_query(token, "session"))
    :ok
  end

  def total_users() do
    Users
    |> select(count())
    |> Repo.one()
  end

  def fetch_or_create_user(attrs) do
    case get_users_by_email(attrs.email) do
      %Users{} = user -> {:ok, user}
      _ -> %Users{} |> Users.registration_changeset(attrs) |> Repo.insert()
    end
  end
end
