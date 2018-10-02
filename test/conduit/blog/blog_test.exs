defmodule Conduit.BlogTest do
  use Conduit.DataCase

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article

  setup [:create_author]

  describe "list articles" do
    setup [:create_author, :publish_articles]

    @tag :integration
    @tag article_count: 2
    test "should list articles by published date", %{articles: [article_1, article_2]} do
      assert {[article_2, article_1], 2} == Blog.list_articles()
    end

    @tag :integration
    @tag article_count: 2
    test "should limit articles", %{articles: [_, article_2]} do
      assert {[article_2], 2} == Blog.list_articles(%{limit: 1})
    end

    @tag :integration
    @tag article_count: 2
    test "should paginate articles", %{articles: [article_1, _]} do
      assert {[article_1], 2} == Blog.list_articles(%{offset: 1})
    end

    @tag :integration
    @tag article_count: 2
    test "should filter by author", %{articles: _} do
      assert {[], 0} == Blog.list_articles(%{author: "unknown"})
    end

    @tag :integration
    @tag article_count: 2
    test "should filter by author, returning only their articles", %{author: author} do
      %{username: username} = author

      assert {[article_1, article_2], 2} = Blog.list_articles(%{author: username})
      assert %{author_username: ^username} = article_1
      assert %{author_username: ^username} = article_2
    end

    @tag :integration
    @tag article_count: 2
    test "should filter by tag", %{articles: _} do
      tag = "unknown"
      assert {[], 0} == Blog.list_articles(%{tag: tag})
    end

    @tag :integration
    @tag article_count: 2
    test "should filter by tag, returning only tagged articles", %{
      articles: [article_1, article_2]
    } do
      tag = Enum.random(article_1.tags)
      assert {[^article_2, ^article_1], 2} = Blog.list_articles(%{tag: tag})
    end
  end

  describe "publish article" do
    @tag :integration
    test "should succeed with valid data", %{author: author} do
      article_attrs = build(:article, title: "title")
      assert {:ok, %Article{} = article} = Blog.publish_article(author, article_attrs)

      assert article.title == article_attrs.title
      assert article.slug =~ article_attrs.title
      assert article.description == article_attrs.description
      assert article.body == article_attrs.body

      assert article.tags == article_attrs.tags
      assert article.author_username == author.username
      assert article.author_bio == author.bio
      assert article.author_image == author.image
    end

    @tag :integration
    test "should generate unique URL slug", %{author: author} do
      title = "title"
      attrs = build(:article, title: title)

      assert {:ok, %Article{} = article_0} = Blog.publish_article(author, attrs)
      assert article_0.slug =~ title

      assert {:ok, %Article{} = article_1} = Blog.publish_article(author, attrs)
      refute article_1.slug == article_0.slug
      assert article_1.slug =~ title
    end
  end
end
