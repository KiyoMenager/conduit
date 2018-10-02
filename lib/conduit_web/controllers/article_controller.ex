defmodule ConduitWeb.ArticleController do
  use ConduitWeb, :controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article

  action_fallback(ConduitWeb.FallbackController)

  def create(conn, %{"article" => article_params}) do
    # with {:ok, %Article{} = article} <- Blog.create_article(article_params) do
    #   conn
    #   |> put_status(:created)
    #   |> put_resp_header("location", article_path(conn, :show, article))
    #   |> render("show.json", article: article)
    # end
  end
end
