defmodule Conduit.Blog.Supervisor do
  use Supervisor

  alias Conduit.Blog

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    Supervisor.init(
      [
        Blog.Projectors.Article,
        Blog.Workflows.CreateAuthorFromUser
      ],
      strategy: :one_for_one
    )
  end
end
