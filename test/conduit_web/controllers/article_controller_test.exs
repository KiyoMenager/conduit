defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article

  # def fixture(:article) do
  #   {:ok, article} = Blog.create_article(@create_attrs)
  #   article
  # end
  #
  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "publish article" do
    @tag :web
    test "renders article when data is valid", %{conn: conn} do
      conn = post(authenticated_conn(conn), article_path(conn, :create), article: build(:article))
      json = json_response(conn, 201)["article"]
      created_at = json["createdAt"]
      updated_at = json["updatedAt"]

      assert json == %{
               "slug" => "some slug",
               "title" => "some title",
               "description" => "some description",
               "body" => "some body",
               "tagList" => [],
               "createdAt" => createdAt,
               "updatedAt" => updatedAt,
               "favorited" => false,
               "favoritesCount" => 0,
               "author" => %{
                 "bio" => "some author_bio",
                 "image" => "some author_image",
                 "username" => "some author_username"
               }
             }

      refute created_at == ""
      refute updated_at == ""
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, article_path(conn, :create), article: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "update article" do
  #   setup [:create_article]
  #
  #   test "renders article when data is valid", %{conn: conn, article: %Article{id: id} = article} do
  #     conn = put(conn, article_path(conn, :update, article), article: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]
  #
  #     conn = get(conn, article_path(conn, :show, id))
  #
  #     assert json_response(conn, 200)["data"] == %{
  #              "id" => id,
  #              "author_bio" => "some updated author_bio",
  #              "author_image" => "some updated author_image",
  #              "author_username" => "some updated author_username",
  #              "author_uuid" => "some updated author_uuid",
  #              "body" => "some updated body",
  #              "description" => "some updated description",
  #              "favorite_count" => 43,
  #              "published_at" => ~N[2011-05-18 15:01:01.000000],
  #              "slug" => "some updated slug",
  #              "tags" => [],
  #              "title" => "some updated title"
  #            }
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn, article: article} do
  #     conn = put(conn, article_path(conn, :update, article), article: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end
  #
  # describe "delete article" do
  #   setup [:create_article]
  #
  #   test "deletes chosen article", %{conn: conn, article: article} do
  #     conn = delete(conn, article_path(conn, :delete, article))
  #     assert response(conn, 204)
  #
  #     assert_error_sent(404, fn ->
  #       get(conn, article_path(conn, :show, article))
  #     end)
  #   end
  # end
  #
  # defp create_article(_) do
  #   article = fixture(:article)
  #   {:ok, article: article}
  # end
end
