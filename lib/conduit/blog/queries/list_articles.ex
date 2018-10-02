defmodule Conduit.Blog.Queries.ListArticles do
  import Ecto.Query, warn: false

  alias Conduit.Blog.Projections.Article

  defmodule Options do
    defstruct limit: 20,
              offset: 0,
              author: nil,
              tag: nil

    use ExConstructor
  end

  def paginate(params, repo) do
    options = Options.new(params)

    articles = query(options) |> entries(options) |> repo.all()
    total_count = query(options) |> count() |> repo.aggregate(:count, :uuid)

    {articles, total_count}
  end

  defp query(options) do
    from(a in Article)
    |> filter_by_author_username(options)
    |> filter_by_tag(options)
  end

  defp entries(query, %Options{limit: limit, offset: offset}) do
    query
    |> order_by([a], desc: a.published_at)
    |> limit(^limit)
    |> offset(^offset)
  end

  defp count(query) do
    query
    |> select([:uuid])
  end

  # Filters

  defp filter_by_author_username(query, %Options{author: nil}), do: query

  defp filter_by_author_username(query, %Options{author: username}) do
    where(query, author_username: ^username)
  end

  defp filter_by_tag(query, %Options{tag: nil}), do: query

  defp filter_by_tag(query, %Options{tag: tag}) do
    from(a in query, where: fragment("? @> ?", a.tags, [^tag]))
  end
end
