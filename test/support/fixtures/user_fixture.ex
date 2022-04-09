defmodule MyApp.UserFixture do
  @moduledoc false

  def create_user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test@test.com",
        password: "test1234"
      })
      |> MyApp.Account.create_user

    user
  end
end
