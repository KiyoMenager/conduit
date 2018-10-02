defmodule Conduit.Factory do
  use ExMachina

  def user_aggregate_factory do
    %{
      email: "seb@example.com",
      username: "sebastian",
      password: "password",
      bio: "I like music",
      image: "https://i.stack.imgur.com/xHWG8.jpg"
    }
  end

  alias Conduit.Accounts.User.Commands.RegisterUser

  def register_user_factory do
    build(:user_aggregate)
    |> Map.put(:user_uuid, UUID.uuid4())
    |> RegisterUser.new()
  end

  def article_factory do
    %{
      slug: "how-to-train-your-dragon",
      title: "How to train your dragon",
      description: "Ever wonder how?",
      body: "You have to believe",
      tag_list: ["dragons", "training"],
      author_uuid: UUID.uuid4()
    }
  end

  alias Conduit.Blog.Commands.PublishArticle

  def publish_article_factory do
    build(:article)
    |> PublishArticle.new()
  end
end
