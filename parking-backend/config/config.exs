# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :findmeaparkingspace_backend,
  ecto_repos: [FindmeaparkingspaceBackend.Repo]

# Configures the endpoint
config :findmeaparkingspace_backend, FindmeaparkingspaceBackend.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RKeA8NDvv9GMh68F3to04RXycsYBQWzjELeRARGW2Sd24BChN4POij/zPliaQSCb",
  render_errors: [view: FindmeaparkingspaceBackend.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FindmeaparkingspaceBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :guardian, Guardian,
issuer: "FindmeaparkingspaceBackend",
ttl: { 30, :days },
allowed_drift: 2000,
secret_key: "cZ8B2scS/gyEbOJbR/LyaYnALZTZMhchs+oAD8t+oBP3emiaBSdQ5juaWKA/pn/I",
serializer: FindmeaparkingspaceBackend.GuardianSerializer

config :canary, unauthorized_handler: {FindmeaparkingspaceBackend.SessionController, :unauthorize}

config :findmeaparkingspace_backend, gmaps_api_key: "AIzaSyCq8dEH4RJn6ueG5b9qKi-fhNqHQ3Iqp5I"

# General application configuration
config :findmeaparkingspace_backend, FindmeaparkingspaceBackend.Repo,
extensions: [{Geo.PostGIS.Extension, library: Geo}],
types: FindmeaparkingspaceBackend.PostgresTypes

config :findmeaparkingspace_backend, FindmeaparkingspaceBackend.Scheduler,
jobs: [
  # Runs on 1st of every month:
  {"0 5 1 * *", {FindmeaparkingspaceBackend.InvoiceAPIController, :monthly_bill, []}}, #30 0 1 * *
]
