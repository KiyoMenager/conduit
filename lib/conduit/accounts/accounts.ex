defmodule Conduit.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Conduit.Accounts.User.Commands.RegisterUser
  alias Conduit.Accounts.User.Queries.UserByName
  alias Conduit.Accounts.Projections.User
  alias Conduit.Repo
  alias Conduit.Router

  @doc """
  Gets an existing user by their username, or return nil
  """
  def user_by_username(username) when is_binary(username) do
    username
    |> String.downcase()
    |> UserByName.new()
    |> Repo.one()
  end

  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    register_user =
      attrs
      |> RegisterUser.new()
      |> RegisterUser.assign_uuid(uuid)
      |> RegisterUser.downcase_username()

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
