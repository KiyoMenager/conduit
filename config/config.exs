# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :conduit, ecto_repos: [Conduit.Repo]

# Configures the endpoint
config :conduit, ConduitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Udp68C/bc0q7OuQwgVQNyD81KvOgobPypZ3SyF34cOxGCSs7mKvilPbvWftDwOCK",
  render_errors: [view: ConduitWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Conduit.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :commanded, event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections, repo: Conduit.Repo

config :vex,
  sources: [
    Conduit.Support.Validators,
    Vex.Validators
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
