defmodule Conduit.Blog.Projections.Article do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "blog_articles" do
    field(:title, :string)
    field(:slug, :string)
    field(:body, :string)
    field(:description, :string)
    field(:favorite_count, :integer)
    field(:published_at, :naive_datetime)
    field(:tags, {:array, :string})

    field(:author_bio, :string)
    field(:author_image, :string)
    field(:author_username, :string)
    field(:author_uuid, :binary)

    timestamps()
  end
end
