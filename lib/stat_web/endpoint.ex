defmodule StatWeb.Endpoint do
  use Absinthe.Phoenix.Endpoint
  use Phoenix.Endpoint, otp_app: :stat


  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :stat,
    gzip: true,
    only: StatWeb.static_paths()


  plug Plug.Static,
    at: "/webapp",
    from: {:stat, "priv/static/webapp"},
    gzip: true

  plug Plug.Static,
    at: "/kaffy", # or "/path/to/your/static/kaffy"
    from: :kaffy,
    gzip: false,
    only: ~w(assets)

  socket "/socket", StatWeb.UserSocket,
    websocket: true,
    longpoll: true

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :stat
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug StatWeb.UserAuth

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session,
    store: :cookie,
    key: "_stat_key",
    signing_salt: "fCcVZXCB" # TODO: Change this to something secure
  plug StatWeb.Router,

  pubsub_server: Stat.PubSub
end
