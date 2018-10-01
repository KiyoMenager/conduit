defmodule Conduit.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Conduit.Accounts.User.Commands.RegisterUser
  alias Conduit.Accounts.Projections.User
  alias Conduit.Repo
  alias Conduit.Router

  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    register_user =
      attrs
      |> assign(:user_uuid, uuid)
      |> RegisterUser.new()

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

  defp assign(attrs, key, val) do
    Map.put(attrs, key, val)
  end
end
