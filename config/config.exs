# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rent_division,
  ecto_repos: [RentDivision.Repo]

# Configures the endpoint
config :rent_division, RentDivisionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1XaH+ubm5PWkjIziPI5AxLymaZjyLz9v2ShWR72aobzfbcOPKxJv0llvgs4LEceW",
  render_errors: [view: RentDivisionWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: RentDivision.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "yKuK/EBq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
