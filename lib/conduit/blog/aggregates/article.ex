defmodule Conduit.Blog.Aggregates.Article do
  defstruct [
    :uuid,
    :author_uuid,
    :slug,
    :title,
    :description,
    :body,
    :tags
  ]

  alias Conduit.Blog.Commands.PublishArticle
  alias Conduit.Blog.Events.ArticlePublished

  @doc """
  Publishes an article.

  """
  def execute(%__MODULE__{uuid: nil} = event, %PublishArticle{} = publish) do
    %ArticlePublished{
      article_uuid: publish.article_uuid,
      author_uuid: publish.author_uuid,
      slug: publish.slug,
      title: publish.title,
      description: publish.description,
      body: publish.body,
      tags: publish.tags
    }
  end

  def apply(%__MODULE__{} = article, %ArticlePublished{} = event) do
    %__MODULE__{
      article
      | uuid: event.article_uuid,
        author_uuid: event.author_uuid,
        slug: event.slug,
        title: event.title,
        description: event.description,
        tags: event.tags
    }
  end
end
