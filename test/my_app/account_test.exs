defmodule MyApp.AccountTest do
  use MyApp.DataCase

  alias MyApp.Account
  alias MyApp.Account.User
  alias MyApp.Guardian
  import MyApp.UserFixture

  test "create_user/1 creates a user with valid data" do
    valid_attrs = %{email: "test@test.com", password: "test1234"}
    {:ok, %User{} = user} = Account.create_user(valid_attrs)

    assert user.email === valid_attrs.email
    assert user.password_hash !== nil
  end

  test "create_user/1 returns error with invalid data" do
    assert {:error, %Ecto.Changeset{}} = Account.create_user()
    assert {:error, %Ecto.Changeset{}} = Account.create_user(%{email: "test@test.com", password: "짧은암호"})
  end

  test "create_user/1 returns error if using already registered email" do
    create_user_fixture()

    assert {:error, %Ecto.Changeset{}} = Account.create_user(%{email: "test@test.com", password: "test1234"})
  end

  test "get_user_by_id!/1 returns User strcut with valid id" do
    create_user_fixture(%{email: "test@test.com"})

    user = Account.get_user_by_id!(1)
    assert user.id === 1
    assert user.email === "test@test.com"
  end

  test "get_user_by_id!/1 throw error with invalid id" do
    assert_raise Ecto.NoResultsError, fn ->
      Account.get_user_by_id!(-1)
    end
  end

  test "sign_up/1 returns JWT token with valid attrs" do
    valid_attrs = %{email: "test@test.com", password: "test1234"}

    assert {:ok, token, _claims} = Account.sign_up(valid_attrs)
    assert token !== ""
  end

  test "sign_up/1 returns error with invalid attrs" do
    invalid_attrs = %{email: "test@test.com", password: ""}

    assert {:error, %Ecto.Changeset{}} = Account.sign_up(invalid_attrs)
  end

  test "sign_in/2 returns user with valid email and password" do
    valid_attrs = %{email: "test@test.com", password: "test1234"}
    user = create_user_fixture(valid_attrs)

    {:ok, token, _} = Account.sign_in(valid_attrs.email, valid_attrs.password)
    {:ok, claims} = Guardian.decode_and_verify(token)

    assert claims["sub"] === user.id |> to_string
  end

  test "sign_in/2 returns error with invlid email and password" do
    valid_attrs = %{email: "test@test.com", password: "test1234"}
    create_user_fixture(valid_attrs)

    assert {:error, :unauthorized} = Account.sign_in("wrong email", valid_attrs.password)
    assert {:error, :unauthorized} = Account.sign_in(valid_attrs.email, "wrong password")
  end
end
