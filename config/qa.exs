import Config

# Configure your database
config :stat, Stat.Repo,
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: false,
  adapter: Ecto.Adapters.Postgres


# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :stat, StatWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :stat, StatWeb.Endpoint,
  check_origin: false,
  code_reloader: false,
  cache_static_manifest: "priv/static/cache_manifest.json",
  http: [ip: {0,0,0,0}, port: 4000],
  debug_errors: true,
  secret_key_base: "4nPmRtya9Og/L7rj7bDHuOjwsj2BO4Doy05U+3c8yOVl6oDET70JJUIlFHbqzvxN"

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

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
