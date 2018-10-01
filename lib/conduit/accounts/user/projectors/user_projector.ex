defmodule Conduit.Accounts.User.Projectors.UserProjector do
  use Commanded.Projections.Ecto,
    name: "Accounts.User.Projectors.UserProjector",
    consistency: :strong

  alias Conduit.Accounts.User.Events.UserRegistered
  alias Conduit.Accounts.Projections.User

  project %UserRegistered{} = registered do
    Ecto.Multi.insert(multi, :user, %User{
      uuid: registered.user_uuid,
      username: registered.username,
      email: registered.email,
      hashed_password: registered.hashed_password,
      bio: nil,
      image: nil
    })
  end
end
