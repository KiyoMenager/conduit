defmodule Conduit.Accounts.UserAggregate do
  defstruct [
    :uuid,
    :username,
    :email,
    :hashed_password
  ]

  alias Conduit.Accounts.UserAggregate
  alias Conduit.Accounts.User.Commands.RegisterUser
  alias Conduit.Accounts.User.Events.UserRegistered

  @doc """
  Register a new user.

  """
  def execute(%UserAggregate{}, %RegisterUser{} = cmd) do
    %UserRegistered{
      user_uuid: cmd.user_uuid,
      username: cmd.username,
      email: cmd.email,
      hashed_password: cmd.hashed_password
    }
  end

  def apply(%UserAggregate{} = user, %UserRegistered{} = event) do
    %UserAggregate{
      user
      | uuid: event.user_uuid,
        username: event.username,
        email: event.email,
        hashed_password: event.hashed_password
    }
  end
end
