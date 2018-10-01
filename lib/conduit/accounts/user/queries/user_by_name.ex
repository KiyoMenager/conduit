defmodule Conduit.Accounts.User.Queries.UserByName do
  import Ecto.Query

  alias Conduit.Accounts.Projections.User

  def new(username) do
    from(u in User, where: u.username == ^username)
  end
end
