defmodule Conduit.Blog.Commands.CreateAuthor do
  defstruct author_uuid: "",
            user_uuid: "",
            username: ""

  use ExConstructor
  use Vex.Struct

  validates(:author_uuid, uuid: true)
  validates(:user_uuid, uuid: true)

  validates(
    :username,
    presence: true,
    format: [with: ~r/^[a-z0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true
  )

  @doc """
  Assigns a unique identity
  """
  def assign_uuid(%__MODULE__{} = create_author, uuid) do
    %__MODULE__{create_author | author_uuid: uuid}
  end
end
