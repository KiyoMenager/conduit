defmodule Conduit.Accounts.Supervisor do
  use Supervisor

  alias Conduit.Accounts

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    Supervisor.init(
      [
        Accounts.User.Projectors.UserProjector
      ],
      strategy: :one_for_one
    )
  end
end
