# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :msmarket,
  ecto_repos: [Msmarket.Repo]

# Configures the endpoint
config :msmarket, MsmarketWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "loDffZLlQH7VyUGB9kG9jkcb9346T0acT7Exgg3F/4tZs75sonmE3uf0GjIvSyN3",
  render_errors: [view: MsmarketWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Msmarket.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :msmarket, :generators,
  migration: true,
  binary_id: true,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"

config :msmarket, MsmarketWeb.Guardian,
  issuer: "msmarket",
  secret_key: "4RCxrG/mXaGavMuwbDXVpYDRoTmMHhulZ82K2wjypV+rVj5nKjejXLV5nbvbEcaN"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
