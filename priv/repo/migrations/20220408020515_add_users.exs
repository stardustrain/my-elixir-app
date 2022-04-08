defmodule MyApp.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :string
      add :is_admin, :boolean
      add :is_super_user, :boolean
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
