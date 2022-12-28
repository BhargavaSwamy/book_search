defmodule BookSearchWeb.TagView do
  use BookSearchWeb, :view

  def tag_options, do: BookSearch.Tags.list_tags() |> Enum.map(fn tag -> {tag.name, tag.id} end)
  
end
