defmodule Conduit.Fixture do
  import Conduit.Factory

  alias Conduit.{Accounts, Blog}

  def register_user(_) do
    {:ok, user} = fixture(:user)

    [user: user]
  end

  def create_author(%{user: user}) do
    {:ok, author} = fixture(:author, user_uuid: user.uuid)

    [
      author: author
    ]
  end

  def create_author(_context) do
    {:ok, author} = fixture(:author, user_uuid: UUID.uuid4())

    [
      author: author
    ]
  end

  def publish_articles(%{author: author} = context) do
    count = Map.get(context, :article_count, 2)

    articles =
      Enum.map(1..count, fn i ->
        {:ok, article} =
          fixture(:article, author: author, title: "article #{i}", body: "article #{i} body")

        article
      end)

    [articles: articles]
  end

  def fixture(schema, attrs \\ [])

  def fixture(:user, attrs) do
    build(:user_aggregate, attrs) |> Accounts.register_user()
  end

  def fixture(:author, attrs) do
    build(:author, attrs) |> Blog.create_author()
  end

  def fixture(:article, attrs) do
    author = Keyword.get(attrs, :author, fixture(:author))

    author |> Blog.publish_article(build(:article, attrs))
  end
end
