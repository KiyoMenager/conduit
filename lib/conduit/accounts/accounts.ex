defmodule Conduit.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Conduit.Accounts.User.Commands.RegisterUser
  alias Conduit.Accounts.User.Queries.{UserByName, UserByEmail}
  alias Conduit.Accounts.Projections.User
  alias Conduit.Repo
  alias Conduit.Router

  @doc """
  Gets a single user by its UUID

  """
  def user_by_uuid(uuid) when is_binary(uuid) do
    Repo.get(User, uuid)
  end

  @doc """
  Gets an existing user by their username, or return nil

  """
  def user_by_username(username) when is_binary(username) do
    username
    |> String.downcase()
    |> UserByName.new()
    |> Repo.one()
  end

  @doc """
  Gets an existing user by their email address, or return nil

  """
  def user_by_email(email) when is_binary(email) do
    email
    |> String.downcase()
    |> UserByEmail.new()
    |> Repo.one()
  end

  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    register_user =
      attrs
      |> RegisterUser.new()
      |> RegisterUser.assign_uuid(uuid)
      |> RegisterUser.downcase_username()
      |> RegisterUser.downcase_email()
      |> RegisterUser.hash_password()

    with :ok <- Router.dispatch(register_user, consistency: :strong) do
      read(User, uuid)
    else
      reply -> reply
    end
  end

  defp read(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
