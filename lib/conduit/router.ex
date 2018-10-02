defmodule Conduit.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.UserAggregate
  alias Conduit.Accounts.User.Commands.RegisterUser
  alias Conduit.Blog.Aggregates.{Author, Article}
  alias Conduit.Blog.Commands.{CreateAuthor, PublishArticle}
  alias Conduit.Support.Middleware.{Validate, Uniqueness}

  middleware(Validate)
  middleware(Uniqueness)

  identify(UserAggregate, by: :user_uuid, prefix: "user-")
  identify(Author, by: :author_uuid, prefix: "author-")
  identify(Article, by: :article_uuid, prefix: "article-")

  dispatch([RegisterUser], to: UserAggregate)
  dispatch([CreateAuthor], to: Author)
  dispatch([PublishArticle], to: Article)
end
