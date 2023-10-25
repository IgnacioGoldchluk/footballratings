defmodule Footballratings.AccountsTest do
  use Footballratings.DataCase

  alias Footballratings.Accounts

  import Footballratings.AccountsFixtures
  alias Footballratings.Accounts.{Users, UsersToken}

  describe "get_users_by_email/1" do
    test "does not return the users if the email does not exist" do
      refute Accounts.get_users_by_email("unknown@example.com")
    end

    test "returns the users if the email exists" do
      %{id: id} = users = users_fixture()
      assert %Users{id: ^id} = Accounts.get_users_by_email(users.email)
    end
  end

  describe "get_users_by_username/1" do
    test "returns user if the username exists" do
      refute Accounts.get_users_by_username("UnknownUser")
    end

    test "returns the user if the username exists" do
      %{username: username, id: id} = users_fixture()
      refute username == nil
      assert %Users{id: ^id} = Accounts.get_users_by_username(username)
    end
  end

  describe "get_users!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_users!(-1)
      end
    end

    test "returns the users with the given id" do
      %{id: id} = users = users_fixture()
      assert %Users{id: ^id} = Accounts.get_users!(users.id)
    end
  end

  describe "register_users/1" do
    test "requires email and password to be set" do
      {:error, changeset} = Accounts.register_users(%{})

      assert %{
               password: ["can't be blank"],
               email: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email and password when given" do
      {:error, changeset} = Accounts.register_users(%{email: "not valid", password: "not valid"})

      assert %{
               email: ["must have the @ sign and no spaces"],
               password: [
                 "at least one digit or punctuation character",
                 "at least one upper case character"
               ]
             } = errors_on(changeset)
    end

    test "validates maximum values for email and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.register_users(%{email: too_long, password: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates email uniqueness" do
      %{email: email} = users_fixture()
      {:error, changeset} = Accounts.register_users(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Accounts.register_users(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "registers users with a hashed password" do
      email = unique_users_email()
      {:ok, users} = Accounts.register_users(valid_users_attributes(email: email))
      assert users.email == email
      assert is_binary(users.hashed_password)
      assert is_nil(users.confirmed_at)
      assert is_nil(users.password)
    end
  end

  describe "change_users_username/2" do
    test "returns a users changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_users_username(%Users{})
      assert changeset.required == [:username]
    end
  end

  describe "update_users_username/2" do
    setup do
      %{users: users_fixture()}
    end

    test "updates the username with a valid username", %{users: users} do
      name = "Test123"
      assert {:ok, _} = Accounts.update_users_username(users, name)

      assert %Users{username: ^name} = Accounts.get_users!(users.id)
    end

    test "does not update if the username is invalid", %{users: users} do
      name = "Inv@L!D"
      assert {:error, _, _, _} = Accounts.update_users_username(users, name)

      refute Accounts.get_users!(users.id).username == name
    end

    test "does not update if the username is duplicated", %{users: users} do
      name = "User123"
      assert {:ok, _} = Accounts.update_users_username(users, name)

      users2 = users_fixture()
      assert {:error, _, _, _} = Accounts.update_users_username(users2, name)

      assert Accounts.get_users!(users.id).username == name
      refute Accounts.get_users!(users2.id).username == name
    end
  end

  describe "generate_users_session_token/1" do
    setup do
      %{users: users_fixture()}
    end

    test "generates a token", %{users: users} do
      token = Accounts.generate_users_session_token(users)
      assert users_token = Repo.get_by(UsersToken, token: token)
      assert users_token.context == "session"

      # Creating the same token for another users should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UsersToken{
          token: users_token.token,
          users_id: users_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_users_by_session_token/1" do
    setup do
      users = users_fixture()
      token = Accounts.generate_users_session_token(users)
      %{users: users, token: token}
    end

    test "returns users by token", %{users: users, token: token} do
      assert session_users = Accounts.get_users_by_session_token(token)
      assert session_users.id == users.id
    end

    test "does not return users for invalid token" do
      refute Accounts.get_users_by_session_token("oops")
    end

    test "does not return users for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UsersToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_users_by_session_token(token)
    end
  end

  describe "delete_users_session_token/1" do
    test "deletes the token" do
      users = users_fixture()
      token = Accounts.generate_users_session_token(users)
      assert Accounts.delete_users_session_token(token) == :ok
      refute Accounts.get_users_by_session_token(token)
    end
  end

  describe "inspect/2 for the Users module" do
    test "does not include password" do
      refute inspect(%Users{password: "123456"}) =~ "password: \"123456\""
    end
  end

  describe "total_users/0" do
    test "returns the number of users" do
      assert 0 == Accounts.total_users()
      users_fixture()
      assert 1 == Accounts.total_users()
    end
  end

  describe "fetch_or_create_user/1" do
    setup do
      %{users: users_fixture()}
    end

    test "returns existing user if e-mail exists", %{users: users} do
      {:ok, user} = Accounts.fetch_or_create_user(%{email: users.email})
      assert user.id == users.id
      assert 1 == Accounts.total_users()
    end

    test "creates new user if e-mail does not exist" do
      {:ok, %Users{}} =
        Accounts.fetch_or_create_user(%{email: "new@email.com", password: "Pass_word123"})
    end
  end
end
