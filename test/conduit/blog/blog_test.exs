defmodule Conduit.BlogTest do
  use Conduit.DataCase

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article

  setup [:create_author]

  describe "publish article" do
    @tag :integration
    test "should succeed with valid data", %{author: author} do
      article_attrs = build(:article)
      assert %Article{} = article = Blog.publish_article(author, article_attrs)

      assert article.slug == article_attrs.slug
      assert article.title == article_attrs.title
      assert article.description == article_attrs.description
      assert article.body == article_attrs.body

      assert article.tags == article_attrs.tags
      assert article.author_username == author.username
      assert article.author_bio == author.bio
      assert article.author_image == author.image
    end

    @tag :integration
    test "should generate unique URL slug", %{author: author} do
      title = ""
      attrs = build(:article, title: title)

      assert %Article{} = article_0 = Blog.publish_article(author, attrs)

      assert article_0.slug == title

      assert %Article{} = article_1 = Blog.publish_article(author, attrs)

      assert article_1.slug == title
    end
  end

  defp create_author(context) do
    {:ok, author} = fixture(:author)

    Map.put(context, :author, author)
  end
end
