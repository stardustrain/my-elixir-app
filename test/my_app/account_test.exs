defmodule MyApp.AccountTest do
  use MyApp.DataCase

  alias MyApp.Account
  alias MyApp.Account.User
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
end
