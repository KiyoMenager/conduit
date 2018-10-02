defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
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
