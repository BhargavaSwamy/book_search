defmodule BookSearch.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    belongs_to :author, BookSearch.Authors.Author

    many_to_many :tags, BookSearch.Tags.Tag, join_through: "book_tags", on_replace: :delete
    has_one :book_content, BookSearch.Books.BookContent
    timestamps()
  end

  @doc false
  def changeset(book, attrs, tags \\[]) do
    book
    |> cast(attrs, [:title, :author_id])
    |> put_assoc(:tags, tags)
    |> cast_assoc(:book_content)
    |> validate_required([:title])
  end
end
