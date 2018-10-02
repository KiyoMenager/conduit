defmodule Conduit.Blog.Commands.PublishArticle do
  defstruct article_uuid: "",
            author_uuid: "",
            slug: "",
            title: "",
            description: "",
            body: "",
            tags: []

  use ExConstructor
  use Vex.Struct

  alias Conduit.Blog.Projections.Author
  alias Conduit.Blog.Slugger

  validates(:author_uuid, uuid: true)
  validates(:author_uuid, uuid: true)

  validates(
    :slug,
    presence: true,
    format: [
      with: ~r/^[a-z0-9\-]+$/,
      allow_nil: true,
      allow_blank: true,
      message: "is invalid"
    ],
    string: true
  )

  validates(:title, presence: [message: "can't be empty"], string: true)
  validates(:description, presence: [message: "can't be empty"], string: true)
  validates(:body, presence: [message: "can't be empty"], string: true)
  validates(:tags, by: &is_list/1)

  @doc """
  Assigns a unique identity

  """
  def assign_uuid(%__MODULE__{} = publish_article, uuid) do
    %__MODULE__{publish_article | article_uuid: uuid}
  end

  @doc """
  Assigns the given author

  """
  def assign_author(%__MODULE__{} = publish_article, %Author{} = author) do
    %__MODULE__{publish_article | author_uuid: author.uuid}
  end

  @doc """
  Generate a unique URL slug for the article.

  """
  def generate_url_slug(%__MODULE__{} = publish_article) do
    case Slugger.slugify(publish_article.title) do
      {:ok, slug} -> %__MODULE__{publish_article | slug: slug}
      _ -> publish_article
    end
  end

  defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields do
    def unique(_) do
      [
        {:slug, "has already been taken"}
      ]
    end
  end
end
