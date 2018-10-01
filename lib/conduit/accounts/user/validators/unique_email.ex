defmodule Conduit.Accounts.User.Validators.UniqueEmail do
  use Vex.Validator

  alias Conduit.Accounts

  def validate(value, _options) do
    Vex.Validators.By.validate(
      value,
      function: &email_available?/1,
      message: "has already been taken"
    )
  end

  defp email_available?(email) do
    case Accounts.user_by_email(email) do
      nil -> true
      _ -> false
    end
  end
end
