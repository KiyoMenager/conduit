defmodule ConduitWeb.FavoriteArticleController do
  use ConduitWeb, :controller
  use Guardian.Phoenix.Controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article

  action_fallback(ConduitWeb.FallbackController)

  plug(
    Guardian.Plug.EnsureAuthenticated,
    %{handler: ConduitWeb.ErrorHandler} when action in [:create]
  )

  plug(
    Guardian.Plug.EnsureResource,
    %{handler: ConduitWeb.ErrorHandler} when action in [:create]
  )

  def create(conn, %{"slug" => slug}, user, _claims) do
    author = Blog.get_author!(user.uuid)

    # with {:ok, %Article{} = article} <- Blog.favorite_article(author, slug) do
    #   conn
    #   |> put_status(:created)
    #   |> render("show.json", article: article)
    # end
  end
end
