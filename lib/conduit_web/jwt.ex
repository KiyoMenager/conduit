defmodule ConduitWeb.JWT do
  @moduledoc """
  JSON web Token helper function, using guardian.

  """
  def generate_jwt(ressource, type \\ :token) do
    case Guardian.encode_and_sign(ressource, type) do
      {:ok, jwt, _full_claims} -> {:ok, jwt}
    end
  end
end
