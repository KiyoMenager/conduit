defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list articles" do
    setup [:create_author, :publish_articles]

    @tag :web
    @tag article_count: 2
    test "should return published articles by published date", %{
      conn: conn,
      author: author,
      articles: [db_article_1, db_article_2]
    } do
      conn = get(conn, article_path(conn, :index))
      json = json_response(conn, 200)

      [fst_article, sec_article] = json["articles"]
      fst_slug = fst_article["slug"]
      fst_created_at = fst_article["createdAt"]
      fst_updated_at = fst_article["updatedAt"]

      sec_slug = sec_article["slug"]
      sec_created_at = sec_article["createdAt"]
      sec_updated_at = sec_article["updatedAt"]

      assert json == %{
               "articles" => [
                 %{
                   "slug" => fst_slug,
                   "title" => db_article_2.title,
                   "description" => db_article_2.description,
                   "body" => db_article_2.body,
                   "tagList" => db_article_2.tags,
                   "createdAt" => fst_created_at,
                   "updatedAt" => fst_updated_at,
                   "favorited" => false,
                   "favoritesCount" => 0,
                   "author" => %{
                     "username" => author.username,
                     "bio" => nil,
                     "image" => nil,
                     "following" => false
                   }
                 },
                 %{
                   "slug" => sec_slug,
                   "title" => db_article_1.title,
                   "description" => db_article_1.description,
                   "body" => db_article_1.body,
                   "tagList" => db_article_1.tags,
                   "createdAt" => sec_created_at,
                   "updatedAt" => sec_updated_at,
                   "favorited" => false,
                   "favoritesCount" => 0,
                   "author" => %{
                     "username" => author.username,
                     "bio" => nil,
                     "image" => nil,
                     "following" => false
                   }
                 }
               ],
               "articlesCount" => 2
             }
    end
  end

  describe "publish article" do
    @tag :web
    test "renders article when data is valid", %{conn: conn} do
      author_attrs = build(:user_aggregate)
      article_params = build(:article, title: "title")

      conn =
        conn
        |> authenticated_conn(author_attrs)
        |> post(article_path(conn, :create), article: article_params)

      json = json_response(conn, 201)["article"]
      slug = json["slug"]
      created_at = json["createdAt"]
      updated_at = json["updatedAt"]

      assert json == %{
               "slug" => slug,
               "title" => article_params.title,
               "description" => article_params.description,
               "body" => article_params.body,
               "tagList" => article_params.tags,
               "createdAt" => created_at,
               "updatedAt" => updated_at,
               "favorited" => false,
               "favoritesCount" => 0,
               "author" => %{
                 "username" => author_attrs.username,
                 "bio" => nil,
                 "image" => nil,
                 "following" => false
               }
             }

      assert slug =~ article_params.title
      refute created_at == ""
      refute updated_at == ""
    end
  end
end
