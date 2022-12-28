defmodule BookSearch.BooksTest do
  use BookSearch.DataCase

  alias BookSearch.Books

  describe "books" do
    alias BookSearch.Books.Book

    import BookSearch.BooksFixtures
    import BookSearch.AuthorsFixtures
    import BookSearch.TagsFixtures

    @invalid_attrs %{title: nil}

    test "list_books/0 returns all books" do
      author = author_fixture()
      book = book_fixture(author: author)
      assert Books.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      author = author_fixture()
      %{title: title, id: id, author_id: author_id} = book_fixture(author: author)
      assert %{title: ^title, id: ^id, author_id: ^author_id} = Books.get_book!(id)
    end

    test "create_book/1 with valid data creates a book" do
      author = author_fixture()
      valid_attrs = %{title: "some title", author: author}
      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      author = author_fixture()
      invalid_attrs = %{title: nil, author: author}
      assert {:error, %Ecto.Changeset{}} = Books.create_book(invalid_attrs)
    end

    test "create_book/1 with tags" do
      author = author_fixture()
      tag1 = tag_fixture()
      tag2 = tag_fixture()
      valid_attrs = %{title: "some title", author: author, tags: [tag1, tag2]}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.title == "some title"
      assert book.tags == [tag1, tag2]
    end

    test "create_book/1 with book content creates a book with associated book content" do
      valid_attrs = %{title: "some title", book_content: %{full_text: "some full text"}}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.title == "some title"
      assert book.book_content.full_text == "some full text"
    end

    # Define a test case called "create a book with associated book content"
    test "create a book with associated book content", %{conn: conn} do
      # Create a map called "book_content" with a key-value pair for the "full_text" field
      book_content = %{full_text: "some full text"}
      # Add the "book_content" map to the "create_attrs" map as a value for the "book_content" key
      create_attrs_with_book_content = Map.put(@create_attrs, :book_content, book_content)

      # Make a POST request to the "Routes.book_path(conn, :create)" route with the modified "create_attrs_with_book_content" map as the request body
      conn = post(conn, Routes.book_path(conn, :create), book: create_attrs_with_book_content)

      # Assert that the response is a redirect, and that the "id" parameter is present in the redirect parameters
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.book_path(conn, :show, id)

      # Make a GET request to the "Routes.book_path(conn, :show, id)" route, using the "id" from the previous step
      conn = get(conn, Routes.book_path(conn, :show, id))

      # Assert that the response has a status code of 200 and that the response body contains the strings "Show Book" and the "full_text" value from the "book_content" map
      response = html_response(conn, 200)
      assert response =~ "Show Book"
      assert response =~ book_content.full_text
    end

    test "update_book/2 with valid data updates the book" do
      author = author_fixture()
      book = book_fixture(author: author)
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs)
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      author = author_fixture()
      book = book_fixture(author: author)
      invalid_attrs = %{title: nil, author: author}
      assert {:error, %Ecto.Changeset{}} = Books.update_book(book, invalid_attrs)

      # %{title: title, id: id, author_id: author_id}  = book
      # assert %{id: ^id, author_id: ^author_id, title: ^title} = Books.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      author = author_fixture()
      book = book_fixture(author: author)
      assert {:ok, %Book{}} = Books.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Books.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      author = author_fixture()
      book = book_fixture(author: author)
      assert %Ecto.Changeset{} = Books.change_book(book)
    end
  end
end
