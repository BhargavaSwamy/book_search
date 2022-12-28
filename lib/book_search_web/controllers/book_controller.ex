defmodule BookSearchWeb.BookController do
  use BookSearchWeb, :controller

  alias BookSearch.{Authors, Books, Tags}
  alias BookSearch.Books.Book

  def index(conn, _params) do
    books =
      Books.list_books()
      |> BookSearch.Repo.preload([:author])
    render(conn, "index.html", books: books)
  end

  def new(conn, _params) do
    changeset = Books.change_book(%Book{})
    authors = Authors.list_authors()
    render(conn, "new.html", changeset: changeset, authors: authors)
  end

  def create(conn, params = %{"book" => book_params}) do
    IO.inspect(params, label: "Params in Book Controller")

    {tag_ids, book_params} = book_params |> Map.pop("tags", [])
    tags = tag_ids |> Enum.map(fn id -> Tags.get_tag!(id) end)

    case Books.create_book(book_params, tags) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        authors = Authors.list_authors()
        render(conn, "new.html", changeset: changeset, authors: authors)
    end
  end

  def show(conn, %{"id" => id}) do
    book =
      Books.get_book!(id)
      |> BookSearch.Repo.preload([:author, :tags, :book_content])
    render(conn, "show.html", book: book)
  end

  def edit(conn, %{"id" => id}) do
    book =
      Books.get_book!(id)
      |> BookSearch.Repo.preload([:book_content, :tags])

      changeset = Books.change_book(book)
    authors = Authors.list_authors()
    render(conn, "edit.html", book: book, changeset: changeset, authors: authors)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Books.get_book!(id)

    case Books.update_book(book, book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        authors = Authors.list_authors()
        render(conn, "edit.html", book: book, changeset: changeset, authors: authors)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Books.get_book!(id)
    {:ok, _book} = Books.delete_book(book)

    conn
    |> put_flash(:info, "Book deleted successfully.")
    |> redirect(to: Routes.book_path(conn, :index))
  end
end
