defmodule StatWeb.Router do
  alias StatWeb.UserAuth
  use StatWeb, :router

  import StatWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {StatWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StatWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", StatWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview
    import Phoenix.LiveDashboard.Router

  scope "/dev" do
    pipe_through [:browser, :require_authenticated_user, :require_admin]

    live_dashboard "/dashboard", metrics: StatWeb.Telemetry
    forward "/mailbox", Plug.Swoosh.MailboxPreview
  end

  ## Authentication routes

  scope "/", StatWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  # Mobile
  scope "/api", StatWeb do
    pipe_through [:api, :require_authenticated_user_api, :fetch_current_user_api]

    post "/users/log_in", UserSessionController, :create_mobile
    post "/users/log_out", UserSessionController, :delete_mobile

    get "/posts/weeklycheckin", PostWeeklyCheckInController, :list_weeklycheckin_mobile
    post "/posts/weeklycheckin", PostWeeklyCheckInController, :create_weeklycheckin_mobile
    get "/posts/moment", PostMomentController, :list_moment_mobile
    post "/posts/moment", PostMomentController, :create_moment_mobile
  end

  scope "/posts/weeklycheckin", StatWeb do
    pipe_through [:browser, :require_authenticated_user, :fetch_current_user]

    get "/new", PostWeeklyCheckInController, :new
    post "/", PostWeeklyCheckInController, :create
    get "/list", PostWeeklyCheckInController, :list
  end

  scope "/posts/moment", StatWeb do
    pipe_through [:browser, :require_authenticated_user, :fetch_current_user]

    get "/new", PostMomentController, :new
    post "/", PostMomentController, :create
    get "/list", PostMomentController, :list
  end

  scope "/", StatWeb do
    pipe_through [:browser, :require_authenticated_user, :fetch_current_user]

    get "/make_admin", AdminController, :create_admin
  end

  scope "/admin", StatWeb do
    pipe_through [:browser, :require_authenticated_user, :require_admin]

    get "/", AdminController, :index
    get "/give_consumables", AdminController, :run_periodic_consumables_scheduler
  end

  scope "/users", StatWeb do
    pipe_through [:browser, :require_authenticated_user, :fetch_current_user]

    get "/profile", ProfileController, :show
    get "/profile/edit", ProfileController, :edit
    put "/profile", ProfileController, :update
  end

  scope "/", StatWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", StatWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end

  defp require_admin(conn, _opts) do
    IO.inspect(Stat.Roles.is_admin?(conn.assigns.current_user.id))
    if Stat.Roles.is_admin?(conn.assigns.current_user.id) do
      conn
    else
      conn
      |> put_flash(:error, "You must be an admin to access this page")
      |> send_resp(404, "Not Found")
      |> halt()
    end
  end

  defp require_authenticated_user_api(conn, _opts) do
    UserAuth.fetch_api_user(conn, conn.params)
  end

  defp fetch_current_user_api(conn, opts) do
    require_authenticated_user_api(conn, opts)
  end
end
