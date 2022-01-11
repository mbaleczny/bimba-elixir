# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :postgres,
  ecto_repos: [Postgres.Repo]

config :web,
  ecto_repos: [Postgres.Repo],
  generators: [context_app: :postgres]

# Configures the endpoint
config :web, Web.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: Web.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Postgres.PubSub,
  live_view: [signing_salt: "Hd8R+U73"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Quantum jobs
config :ztm, Ztm.Scheduler,
  jobs: [
    import_stops: [
      schedule: "@daily",
      task: {Ztm.Workers.ImportStops, :call, []}
    ]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
