defmodule Conduit.Blog.Queries.ArticleBySlug do
  import Ecto.Query, warn: false

  alias Conduit.Blog.Projections.Article

  def new(slug) do
    from(a in Article, where: a.slug == ^slug)
  end
end
