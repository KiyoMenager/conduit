defmodule Conduit.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false

  alias Conduit.Blog.Commands.{CreateAuthor, PublishArticle}
  alias Conduit.Blog.Projections.{Author, Article}
  alias Conduit.Blog.Queries.{ArticleBySlug, ListArticles}
  alias Conduit.{Router, Repo}

  @doc """
  Gets a single author by uuid.

  """
  def get_author!(uuid) do
    Repo.get(Author, uuid)
  end

  @doc """
  Gets a single article by slug or return nil if not found.

  """
  def get_article_by_slug(slug) do
    slug
    |> ArticleBySlug.new()
    |> Repo.one()
  end

  @doc """
  Get an article by its URL slug, or raise an `Ecto.NoResultsError` if not found
  """
  def get_article_by_slug!(slug) do
    slug
    |> ArticleBySlug.new()
    |> Repo.one!()
  end

  @doc """
  Returns most recent articles (globally by default).

  Provide tag, author or favorited query parameters to filter query.

  """
  def list_articles(params \\ %{}) do
    ListArticles.paginate(params, Repo)
  end

  def publish_article(author, article_params) do
    article_uuid = UUID.uuid4()

    publish_article =
      article_params
      |> PublishArticle.new()
      |> PublishArticle.assign_uuid(article_uuid)
      |> PublishArticle.assign_author(author)
      |> PublishArticle.generate_url_slug()

    with :ok <- Router.dispatch(publish_article, consistency: :strong) do
      read(Article, article_uuid)
    end
  end

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
