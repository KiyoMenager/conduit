defmodule Conduit.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Conduit.Blog.Projections.{Author, Article}
  alias Conduit.Blog.Events.{AuthorCreated, ArticlePublished}
  alias Conduit.Repo

  project %AuthorCreated{} = author_created do
    Ecto.Multi.insert(multi, :author, %Author{
      uuid: author_created.author_uuid,
      user_uuid: author_created.user_uuid,
      username: author_created.username,
      bio: nil,
      image: nil
    })
  end

  project %ArticlePublished{} = published, %{created_at: published_at} do
    multi
    |> Ecto.Multi.run(:author, fn _changes ->
      get_author(published.author_uuid)
    end)
    |> Ecto.Multi.run(:article, fn %{author: author} ->
      %Article{
        uuid: published.article_uuid,
        slug: published.slug,
        title: published.title,
        body: published.body,
        description: published.description,
        tags: published.tags,
        published_at: published_at,
        author_username: author.username,
        author_bio: author.bio,
        author_image: author.image
      }
      |> Repo.insert()
    end)
  end

  defp get_author(uuid) do
    case Repo.get(Author, uuid) do
      nil -> {:error, {:author, :not_found}}
      author -> {:ok, author}
    end
  end
end
