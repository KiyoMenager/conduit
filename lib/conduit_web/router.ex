defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(Guardian.Plug.VerifyHeader, realm: "Token")
    plug(Guardian.Plug.LoadResource)
  end

  scope "/api", ConduitWeb do
    pipe_through(:api)

    get("/users", UserController, :current)
    post("/users/login", SessionController, :create)
    post("/users", UserController, :create)

    get("/articles", ArticleController, :index)
    post("/articles", ArticleController, :create)
  end
end
