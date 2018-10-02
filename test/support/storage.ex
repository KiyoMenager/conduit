defmodule Conduit.Storage do
  @moduledoc """
  A module to control stores.
  """

  @doc """
  Resets the the write and the read store.

  """
  def reset!() do
    Application.stop(:conduit)
    Application.stop(:commanded)
    Application.stop(:eventstore)

    reset_event_store()
    reset_read_store()

    Application.ensure_all_started(:conduit)
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
      blog_authors,
      blog_articles,
      projection_versions
    RESTART IDENTITY;
    """
  end
end
