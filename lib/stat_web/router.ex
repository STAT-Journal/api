defmodule StatWeb.Router do
  use StatWeb, :router
  use Kaffy.Routes, scope: "/admin"

  pipeline :kaffy_browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end


  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StatWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: StatWeb.Schema
    forward "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: StatWeb.Schema
  end

  # Enable LiveDashboard and Swoosh mailbox preview
  import Phoenix.LiveDashboard.Router

  scope "/dev" do
    pipe_through [:browser]

    live_dashboard "/dashboard", metrics: StatWeb.Telemetry
    forward "/mailbox", Plug.Swoosh.MailboxPreview

  end

  scope "/verify", StatWeb do
    pipe_through [:browser]

    get "/", UserConfirmationController, :create
  end

  scope "/verify", StatWeb do
    pipe_through [:browser]

    get "/not_found", UserConfirmationController, :not_found
  end

  scope "/webapp", StatWeb do
    pipe_through [:browser]

    get "/", WebAppController, :index
    get "*path", WebAppController, :index
  end


end
