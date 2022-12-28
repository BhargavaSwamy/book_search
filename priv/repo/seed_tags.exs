alias BookSearch.Tags

if Mix.env() == :dev do
  ["fiction", "fantasy", "history", "sci-fi"]
  |> Enum.each(fn tag_name ->
    Tags.create_tag(%{name: tag_name})
  end)
end
