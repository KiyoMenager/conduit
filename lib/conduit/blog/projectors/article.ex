defmodule Conduit.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Conduit.Blog.Projections.Author
  alias Conduit.Blog.Events.AuthorCreated

  project %AuthorCreated{} = author_created do
    Ecto.Multi.insert(multi, :author, %Author{
      uuid: author_created.author_uuid,
      user_uuid: author_created.user_uuid,
      username: author_created.username,
      bio: nil,
      image: nil
    })
  end
end
