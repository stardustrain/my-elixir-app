defmodule MyApp.Account.User do
  use Ecto.Schema
  import Ecto.Query, warn: false

  @timestamps_opts [type: :utc_datetime]

  @derive {Jason.Encoder, except: [:__meta__, :password_hash]}
  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :is_admin, :boolean, default: false
    field :is_super_user, :boolean, default: false
    timestamps()
  end
end
