defmodule ConduitWeb.ConnHelpers do
  import Plug.Conn
  import Conduit.Fixture

  alias Conduit.Accounts.Projections.User

  def authenticated_conn(conn, user_or_attrs \\ %{})

  def authenticated_conn(conn, %User{} = user) do
    with {:ok, jwt} <- ConduitWeb.JWT.generate_jwt(user) do
      put_req_header(conn, "authorization", "Token " <> jwt)
    end
  end

  def authenticated_conn(conn, user_attrs) do
    with {:ok, user} <- fixture(:user, user_attrs),
         {:ok, jwt} <- ConduitWeb.JWT.generate_jwt(user) do
      put_req_header(conn, "authorization", "Token " <> jwt)
    end
  end
end
