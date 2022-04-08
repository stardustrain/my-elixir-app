defmodule MyApp.Account do
  alias MyApp.Repo
  alias MyApp.Account.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert
  end
end
