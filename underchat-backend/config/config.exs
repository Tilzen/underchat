# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :underchat,
  namespace: UnderChat,
  ecto_repos: [UnderChat.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :underchat, UnderChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sDbLUq85X7z5Qqdccvax0IsIgg6vD6gE7x/Utjwva3t3qvs/ToUC+3HkU5itZ88v",
  render_errors: [view: UnderChatWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: UnderChat.PubSub,
  live_view: [signing_salt: "8JlYCS9l"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
