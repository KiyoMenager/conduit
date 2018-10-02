defmodule Conduit.Blog.Events.ArticlePublished do
  @derive [Poison.Encoder]

  defstruct [
    :article_uuid,
    :author_uuid,
    :title,
    :slug,
    :body,
    :description,
    :tags
  ]
end
