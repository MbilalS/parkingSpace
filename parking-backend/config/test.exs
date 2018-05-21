use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :findmeaparkingspace_backend, FindmeaparkingspaceBackend.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :findmeaparkingspace_backend, FindmeaparkingspaceBackend.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "findmeaparkingspace_backend_test",
  hostname: "localhost",
  ownership_timeout: 60000,
  pool: Ecto.Adapters.SQL.Sandbox

  config :hound, driver: "chrome_driver"
  config :findmeaparkingspace_backend, sql_sandbox: true

  config :findmeaparkingspace_backend, gmaps_api_key: "AIzaSyCq8dEH4RJn6ueG5b9qKi-fhNqHQ3Iqp5I"
