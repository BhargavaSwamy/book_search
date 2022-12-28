defmodule BookSearchWeb.Router do
  use BookSearchWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BookSearchWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BookSearchWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/authors", AuthorController
    resources "/books", BookController
    resources "/tags", TagController
  end

  # Other scopes may use custom stacks.
  # scope "/api", BookSearchWeb do
  #   pipe_through :api
  # end
end
