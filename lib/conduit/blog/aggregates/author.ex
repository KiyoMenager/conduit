defmodule Conduit.Blog.Aggregates.Author do
  defstruct [
    :uuid,
    :user_uuid,
    :username,
    :bio,
    :image
  ]

  alias Conduit.Blog.Commands.CreateAuthor
  alias Conduit.Blog.Events.AuthorCreated

  def execute(%__MODULE__{uuid: nil}, %CreateAuthor{} = create) do
    %AuthorCreated{
      author_uuid: create.author_uuid,
      user_uuid: create.user_uuid,
      username: create.username
    }
  end

  def apply(%__MODULE__{} = author, %AuthorCreated{} = created) do
    %__MODULE__{
      author
      | uuid: created.author_uuid,
        user_uuid: created.user_uuid,
        username: created.username
    }
  end
end
