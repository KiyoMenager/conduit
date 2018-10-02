defmodule ConduitWeb.ConnHelpers do
  import Plug.Conn
  import Conduit.Fixture

  def authenticated_conn(conn, user_attrs \\ %{}) do
    with {:ok, user} <- fixture(:user, user_attrs),
         {:ok, jwt} <- ConduitWeb.JWT.generate_jwt(user) do
      put_req_header(conn, "authorization", "Token " <> jwt)
    end
  end
end
