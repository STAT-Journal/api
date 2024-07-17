defmodule StatWeb.Router do
  alias Stat.Guardian
  use StatWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :put_root_layout, html: {StatWeb.Layouts, :root}
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

    get "/:token", UserConfirmationController, :create
  end

  scope "/", StatWeb do
    pipe_through [:browser]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create

    # get "/users/log_in", UserSessionController, :new
    # post "/users/log_in", UserSessionController, :create
    # get "/users/reset_password", UserResetPasswordController, :new
    # post "/users/reset_password", UserResetPasswordController, :create
    # get "/users/reset_password/:token", UserResetPasswordController, :edit
    # put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", StatWeb do
    pipe_through [:browser]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
  end

  scope "/", StatWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
