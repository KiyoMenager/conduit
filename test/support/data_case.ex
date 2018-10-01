defmodule Conduit.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Conduit.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Conduit.DataCase
      import Conduit.Factory
    end
  end

  setup tags do
    Application.stop(:conduit)
    Application.stop(:commanded)
    Application.stop(:eventstore)

    reset_event_store()
    reset_read_store()

    Application.ensure_all_started(:conduit)

    :ok
  end

  defp reset_event_store do
    {:ok, conn} =
      EventStore.configuration()
      |> EventStore.Config.parse()
      |> EventStore.Config.default_postgrex_opts()
      |> Postgrex.start_link()

    EventStore.Storage.Initializer.reset!(conn)
  end

  defp reset_read_store do
    read_store_config = Application.get_env(:conduit, Conduit.Repo)
    {:ok, conn} = Postgrex.start_link(read_store_config)
    Postgrex.query!(conn, truncate_read_store_tables(), [])
  end

  defp truncate_read_store_tables do
    """
    TRUNCATE TABLE
      accounts_users,
      projection_versions
    RESTART IDENTITY;
    """
  end

  # setup tags do
  #   :ok = Ecto.Adapters.SQL.Sandbox.checkout(Conduit.Repo)
  #
  #   unless tags[:async] do
  #     Ecto.Adapters.SQL.Sandbox.mode(Conduit.Repo, {:shared, self()})
  #   end
  #
  #   :ok
  # end

  @doc """
  A helper that transform changeset errors to a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
