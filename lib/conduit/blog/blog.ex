defmodule Conduit.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false

  alias Conduit.Blog.Commands.CreateAuthor
  alias Conduit.Blog.Projections.Author
  alias Conduit.{Router, Repo}

  @doc """
  Creates an author.

  """
  def create_author(%{user_uuid: uuid} = attrs) do
    create_author =
      attrs
      |> CreateAuthor.new()
      |> CreateAuthor.assign_uuid(uuid)

    with :ok <- Router.dispatch(create_author, consistency: :strong) do
      read(Author, uuid)
    end
  end

  defp read(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
