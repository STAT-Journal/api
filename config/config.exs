# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :stat,
  ecto_repos: [Stat.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :stat, StatWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: StatWeb.ErrorHTML, json: StatWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Stat.PubSub

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :stat, Stat.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  stat: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  stat: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Prevent tokens from being logged in the console
config :logger, :filter_parameters, ["token"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Guardian
config :stat, Stat.Guardian,
  issuer: "stat",
  secret_key: "toTw7maGff2I7Bj14oMx0ryAga6qUxg34un6IhUadKN7tkL/NRHr2RwZ6F3bkqdp"

config :guardian, Guardian.DB,
  repo: Stat.Repo, # Add your repository module
  schema_name: "guardian_tokens", # default
  sweep_interval: 60 # default: 60 minutes



# Background jobs
config :stat, Stat.PeriodicConsumablesScheduler,
  cron: "0 * * * *", # every hour
  job: {Stat.PeriodicConsumablesScheduler, :run, []}

config :absinthe,
  schema: StatWeb.Schema
