defmodule Conduit.Blog.Validators.UniqueArticleSlug do
  use Vex.Validator

  alias Conduit.Blog

  def validate(value, _options) do
    Vex.Validators.By.validate(
      value,
      function: &article_available?(&1),
      message: "has already been taken"
    )
  end

  defp article_available?(slug) do
    case Blog.get_article_by_slug(slug) do
      nil -> true
      _ -> false
    end
  end
end
