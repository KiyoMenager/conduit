defmodule ConduitWeb.ConnHelpers do
  import Plug.Conn
  import Conduit.Fixture

  alias ConduitWeb.JWT

  def authenticated_conn(conn, attrs \\ %{}) do
    with {:ok, user} <- fixture(:user, attrs),
         {:ok, jwt} <- ConduitWeb.JWT.generate_jwt(user) do
      put_req_header(conn, "authorization", "Token " <> jwt)
    end
  end
end
