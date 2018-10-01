defmodule Conduit.Accounts.User.Validators.UniqueUsername do
  use Vex.Validator

  alias Conduit.Accounts

  def validate(value, _options) do
    Vex.Validators.By.validate(
      value,
      function: &username_available?/1,
      message: "has already been taken"
    )
  end

  defp username_available?(username) do
    case Accounts.user_by_username(username) do
      nil -> true
      _ -> false
    end
  end
end
