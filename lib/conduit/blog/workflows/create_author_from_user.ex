defmodule Conduit.Blog.Workflows.CreateAuthorFromUser do
  use Commanded.Event.Handler,
    name: 'Blog.Workflows.CreateAuthorFromUser',
    consistency: :strong

  alias Conduit.Accounts.User.Events.UserRegistered
  alias Conduit.Blog

  def handle(%UserRegistered{user_uuid: _, username: _} = e, _metadata) do
    author_params = Map.take(e, [:user_uuid, :username])

    with {:ok, _author} <- Blog.create_author(author_params) do
      :ok
    end
  end
end
