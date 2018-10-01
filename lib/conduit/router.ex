defmodule Conduit.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.UserAggregate
  alias Conduit.Accounts.User.Commands.RegisterUser

  dispatch([RegisterUser], to: UserAggregate, identity: :user_uuid)
end
