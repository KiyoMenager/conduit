defmodule Conduit.Blog.ArticleTest do
  @moduledoc false
  use Conduit.AggregateCase, aggregate: Conduit.Blog.Aggregates.Article

  alias Conduit.Blog.Events.ArticlePublished

  describe "publish article" do
    @tag :unit
    test "should succeed when valid" do
      article_uuid = UUID.uuid4()
      author_uuid = UUID.uuid4()

      command_params = %{article_uuid: article_uuid, author_uuid: author_uuid}
      publish_article = build(:publish_article, command_params)

      assert_events(publish_article, [
        %ArticlePublished{
          article_uuid: article_uuid,
          author_uuid: author_uuid,
          slug: Slugger.slugify_downcase(publish_article.title),
          title: publish_article.title,
          body: publish_article.body,
          description: publish_article.description,
          tags: publish_article.tags
        }
      ])
    end
  end
end
