import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :stat, Stat.Repo,
  database: Path.expand("../stat_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stat, StatWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Yv0OMR+ExMOnB9znf7M/Xe5xFoViXI53HZbUX4p2790Uo4P4vBfwav8xkB6WbPJN",
  server: false

# In test we don't send emails.
config :stat, Stat.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true

config :stat, Stat.Guardian,
issuer: "stat",
secret_key: "toTw7maGff2I7Bj14oMx0ryAga6qUxg34un6IhUadKN7tkL/NRHr2RwZ6F3bkqdp",
token_ttl: %{
  "access" => {30, :minutes},
  "refresh" => {30, :days},
  "confirmation" => {1, :day}
},
serializer: Jason,
token_verify_module: Guardian.Token.Jwt.Verify,
allowed_algos: ["HS512"],
auth_claim: true

config :stat, Stat.GuardianCachex,
  name: :stat_guardian_cache
