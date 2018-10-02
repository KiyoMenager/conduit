defmodule Conduit.Blog.Slugger do
  @moduledoc false

  alias Conduit.Blog

  @doc """
  Slugifies the given text and ensure it's uniqueness.

  A slug will contain only alphanumeric characters (`a-z`, `0-9`) and the
  default separator character (`-`).

  If the generated slug is already taken, append a numeric suffix and keep
  incrementing until a unique slug is found.

  ## Examples

    - "Example article"
      => "example-article", "example-article-2", "example-article-3", etc.

  """
  def slugify(title) do
    title
    |> Slugger.slugify_downcase()
    |> ensure_unique()
  end

  def ensure_unique(slug, suffix \\ 1)
  def ensure_unique("", _), do: ""

  def ensure_unique(slug, suffix) do
    suffixed_slug = suffixed(slug, suffix)

    case exists?(suffixed_slug) do
      true -> ensure_unique(slug, suffix + 1)
      false -> {:ok, suffixed_slug}
    end
  end

  defp exists?(slug) do
    case Blog.get_article_by_slug(slug) do
      nil -> false
      _ -> true
    end
  end

  defp suffixed(slug, 1), do: slug
  defp suffixed(slug, suffix), do: slug <> "-#{suffix}"
end
