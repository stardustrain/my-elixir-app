defmodule MyApp.Account do
  alias MyApp.Repo
  alias MyApp.Account.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert
  end

  def get_user_by_id!(id) do
    User
    |> Repo.get!(id)
  end
end
