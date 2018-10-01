defmodule Conduit.Accounts.Projections.User do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "accounts_users" do
    field(:email, :string, unique: true)
    field(:username, :string, unique: true)
    field(:bio, :string)
    field(:hashed_password, :string)
    field(:image, :string)

    timestamps()
  end
end
