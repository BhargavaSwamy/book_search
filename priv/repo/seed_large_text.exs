alias BookSearch.{Repo, Authors, Authors.Author, Books, Books.Book}

# Author without books
Authors.create_author(%{name: Faker.Lorem.sentence(10)})

# Book without Author
Books.create_book(%{title: Faker.Lorem.sentence(10)})

# Author with a book
{:ok, author} = Authors.create_author(%{name: Faker.Lorem.sentence(10)})

Enum.each(1..10, fn _ ->
  %Book{}
  |> Book.changeset(%{title: Faker.Lorem.sentence(10)})
  |> Ecto.Changeset.put_assoc(:author, author)
  |> Repo.insert!()
end)
