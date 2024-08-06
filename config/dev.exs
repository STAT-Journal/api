import Config

# Configure your database
config :stat, Stat.Repo,
  adapter: Ecto.Adapters.SQLite3,
  database: Path.expand("../stat_dev.db", __DIR__),
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :stat, StatWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {0, 0, 0, 0}, port: 4000],
  url: [host: "localhost"],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "4nPmRtya9Og/L7rj7bDHuOjwsj2BO4Doy05U+3c8yOVl6oDET70JJUIlFHbqzvxN",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:stat, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:stat, ~w(--watch)]}
  ]
# Watch static and templates for browser reloading.
config :stat, StatWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/stat_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :stat, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Include HEEx debug annotations as HTML comments in rendered markup
  debug_heex_annotations: true,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

config :stat, StatWeb.UserConfirmationController,
  mobile_redirect_base: "exp://10.0.0.222:8081", # Change to your dev machine's IP
  desktop_redirect_base: "http://localhost:5173/login/token"

config :stat, Stat.Accounts,
  dicebear_api: "http://localhost:3000"

config :kaffy,
  # required keys
  otp_app: :stat, # required
  ecto_repo: Stat.Repo, # required
  router: StatWeb.Router # required

# Guardian
config :stat, Stat.Guardian,
  issuer: "stat",
  secret_key: "toTw7maGff2I7Bj14oMx0ryAga6qUxg34un6IhUadKN7tkL/NRHr2RwZ6F3bkqdp",
  token_ttl: %{
    "access" => {30, :minutes},
    "refresh" => {30, :days},
    "confirmation" => {1, :day}
  }
