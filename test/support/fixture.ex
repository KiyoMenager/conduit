defmodule Conduit.Fixture do
  import Conduit.Factory

  alias Conduit.{Accounts, Blog}

  def create_author(%{user: user}) do
    {:ok, author} = fixture(:author, user_uuid: user.uuid)

    [
      author: author
    ]
  end

  def fixture(:user, attrs) do
    build(:user, attrs) |> Accounts.register_user()
  end
end
