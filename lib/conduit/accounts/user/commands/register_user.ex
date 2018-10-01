defmodule Conduit.Accounts.User.Commands.RegisterUser do
  defstruct [
    :user_uuid,
    :username,
    :email,
    :password,
    :hashed_password
  ]

  use ExConstructor
  use Vex.Struct

  validates(:user_uuid, uuid: true)

  validates(
    :username,
    presence: [message: "can't be empty"],
    format: [with: ~r/^[a-z0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    unique_username: true
  )

  validates(
    :email,
    presence: [message: "can't be empty"],
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    unique_email: true
  )

  validates(:hashed_password, presence: [message: "can't be empty"], string: true)

  defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields do
    def unique(_),
      do: [
        {:username, "has already been taken"},
        {:email, "has already been taken"}
      ]
  end

  @doc """
  Assigns a unique identity to the user

  """
  def assign_uuid(%__MODULE__{} = register_user, uuid) do
    %__MODULE__{register_user | user_uuid: uuid}
  end

  @doc """
  Downcases the user's username

  """
  def downcase_username(%__MODULE__{} = register_user) do
    %__MODULE__{register_user | username: String.downcase(register_user.username)}
  end

  @doc """
  Downcases the user's username

  """
  def downcase_email(%__MODULE__{} = register_user) do
    %__MODULE__{register_user | email: String.downcase(register_user.email)}
  end
end
