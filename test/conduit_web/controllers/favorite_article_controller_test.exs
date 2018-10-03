defmodule ConduitWeb.FavoriteArticleControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # describe "favorite article" do
  #   setup [:create_author, :publish_articles, :register_user]
  #
  #   @tag :web
  #   @tag article_count: 1
  #   test "should favorite and return the article", %{
  #     conn: conn,
  #     author: author,
  #     articles: articles,
  #     user: user
  #   } do
  #     article = Enum.random(articles)
  #
  #     json =
  #       conn
  #       |> authenticated_conn(user)
  #       |> post(favorite_article_path(conn, :create, article.slug))
  #       |> json_response(201)
  #       |> Map.get("article")
  #
  #     created_at = json["createdAt"]
  #     updated_at = json["updatedAt"]
  #
  #     assert json == %{
  #              "slug" => article.slug,
  #              "title" => article.title,
  #              "description" => article.description,
  #              "body" => article.body,
  #              "tagList" => article.tags,
  #              "createdAt" => created_at,
  #              "updatedAt" => updated_at,
  #              "favorited" => true,
  #              "favoritesCount" => 1,
  #              "author" => %{
  #                "username" => author.username,
  #                "bio" => nil,
  #                "image" => nil,
  #                "following" => false
  #              }
  #            }
  #   end
  # end
end
